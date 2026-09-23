import SwiftUI
import SwiftData
import UIKit

struct DailyMissionsSection: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var clockRevision = 0
    @State private var today = RoutineCompletion.calendarDayKey(for: .now)

    var body: some View {
        TodayMissions(dayKey: today)
            .id(today)
            .task(id: clockRevision) {
                // Sleep until the next local midnight; calendar math handles short/long DST days.
                while !Task.isCancelled {
                    refreshDay()
                    let now = Date.now
                    let calendar = Calendar.autoupdatingCurrent
                    let next = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now))!
                    do { try await Task.sleep(for: .seconds(max(0.1, next.timeIntervalSince(now)))) }
                    catch { return }
                }
            }
            .onChange(of: scenePhase) { _, phase in
                if phase == .active { refreshDay(); clockRevision += 1 }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.NSSystemTimeZoneDidChange)) { _ in refreshDay(); clockRevision += 1 }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in refreshDay(); clockRevision += 1 }
    }

    private func refreshDay() {
        today = RoutineCompletion.calendarDayKey(for: .now)
    }
}

private struct TodayMissions: View {
    let dayKey: String
    @Environment(\.modelContext) private var context
    @Query private var completions: [RoutineCompletion]
    @Query private var stars: [DailyStar]
    @State private var saveFailed = false
    @State private var showCelebration = false
    @State private var earnedNewStar = false

    init(dayKey: String) {
        self.dayKey = dayKey
        _completions = Query(filter: #Predicate<RoutineCompletion> { $0.dayKey == dayKey })
        _stars = Query(filter: #Predicate<DailyStar> { $0.dayKey == dayKey })
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Olivia’s Missions Today ⭐")
                .font(.system(.title2, design: .rounded, weight: .bold))
                .accessibilityAddTraits(.isHeader)
            if !stars.isEmpty {
                Label("Daily Star earned!", systemImage: "star.fill")
                    .font(.system(.headline, design: .rounded))
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.yellow.opacity(0.18), in: RoundedRectangle(cornerRadius: 22))
            }
            ForEach(DailyMission.allCases) { mission in
                MissionCard(mission: mission, isComplete: completions.contains { $0.routineID == mission.id }) {
                    complete(mission)
                }
            }
            #if DEBUG
            Button("Reset today’s missions", systemImage: "arrow.counterclockwise") {
                let currentDay = RoutineCompletion.calendarDayKey(for: .now)
                do {
                    let records = try context.fetch(FetchDescriptor<RoutineCompletion>(predicate: #Predicate { $0.dayKey == currentDay }))
                    for record in records { context.delete(record) }
                    try context.save()
                } catch {
                    context.rollback()
                    saveFailed = true
                }
            }
            .font(.caption)
            .frame(minHeight: 44)
            #endif
        }
        .task {
            // Reconcile today's pre-existing completions without replaying the celebration.
            do {
                if try DailyStarAward.insertIfEarned(in: context) { try context.save() }
            } catch {
                context.rollback()
                saveFailed = true
            }
        }
        .sheet(isPresented: $showCelebration) {
            DailyMissionCelebration(earnedNewStar: earnedNewStar)
                .presentationDragIndicator(.visible)
        }
        .alert("Let’s try again", isPresented: $saveFailed) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("We couldn’t save just now. Please tap again in a moment.")
        }
    }

    private func complete(_ mission: DailyMission) -> Bool {
        // Resolve the date at tap time, including a tap just after midnight.
        let record = RoutineCompletion(routineID: mission.id)
        let key = record.completionKey
        do {
            var request = FetchDescriptor<RoutineCompletion>(predicate: #Predicate { $0.completionKey == key })
            request.fetchLimit = 1
            guard try context.fetch(request).isEmpty else {
                if try DailyStarAward.insertIfEarned(in: context, on: record.completedAt) { try context.save() }
                return false
            }
            context.insert(record)
            let awarded = try DailyStarAward.insertIfEarned(in: context, on: record.completedAt)
            try context.save()
            earnedNewStar = awarded
            let completedDay = record.dayKey
            let todayRecords = try context.fetch(FetchDescriptor<RoutineCompletion>(predicate: #Predicate { $0.dayKey == completedDay }))
            // Only a new completion can trigger this; loading saved history never replays it.
            if DailyMission.allCases.allSatisfy({ mission in todayRecords.contains { $0.routineID == mission.id } }) {
                showCelebration = true
            }
            return true
        } catch {
            context.rollback()
            saveFailed = true
            return false
        }
    }
}

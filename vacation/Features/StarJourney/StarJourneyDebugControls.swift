#if DEBUG
import SwiftUI
import SwiftData

struct StarJourneyDebugControls: View {
    @Environment(\.modelContext) private var context
    @AppStorage("starJourney.debugSeededDays") private var seededDays = ""
    @State private var failed = false
    @State private var confirmClear = false

    var body: some View {
        DisclosureGroup("Star testing (DEBUG)") {
            VStack(alignment: .leading, spacing: 8) {
                Button("Remove today’s star") { removeToday() }
                Button("Seed 1 previous Daily Star") { seed(count: 1) }
                Button("Seed 7 previous Daily Stars") { seed(count: 7) }
                Button("Clear Daily Star test data", role: .destructive) { confirmClear = true }
            }
            .buttonStyle(.bordered)
            .padding(.vertical, 8)
        }
        .font(.caption)
        .confirmationDialog("Clear stars added by these testing controls?", isPresented: $confirmClear) {
            Button("Clear test stars", role: .destructive) { clearTestStars() }
        } message: { Text("Normally earned stars and mission history will stay saved.") }
        .alert("Couldn’t update test stars", isPresented: $failed) {
            Button("OK", role: .cancel) { }
        }
    }

    private func seed(count: Int) {
        do {
            let existing = Set(try context.fetch(FetchDescriptor<DailyStar>()).map(\.dayKey))
            var tracked = Set(seededDays.split(separator: ",").map(String.init))
            let calendar = Calendar.current
            var date = calendar.startOfDay(for: .now)
            var added = 0
            while added < count {
                date = calendar.date(byAdding: .day, value: -1, to: date)!
                let key = RoutineCompletion.calendarDayKey(for: date)
                guard !existing.contains(key) else { continue }
                context.insert(DailyStar(date: date))
                tracked.insert(key)
                added += 1
            }
            try context.save()
            seededDays = tracked.sorted().joined(separator: ",")
        } catch { context.rollback(); failed = true }
    }

    private func removeToday() {
        do {
            let key = RoutineCompletion.calendarDayKey(for: .now)
            for star in try context.fetch(FetchDescriptor<DailyStar>(predicate: #Predicate { $0.dayKey == key })) { context.delete(star) }
            try context.save()
        } catch { context.rollback(); failed = true }
    }

    private func clearTestStars() {
        do {
            let tracked = Set(seededDays.split(separator: ",").map(String.init))
            for star in try context.fetch(FetchDescriptor<DailyStar>()) where tracked.contains(star.dayKey) { context.delete(star) }
            try context.save()
            seededDays = ""
        } catch { context.rollback(); failed = true }
    }
}
#endif

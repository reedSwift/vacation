import Foundation
import SwiftData

@MainActor
enum DailyStarAward {
    /// All four code-defined missions are scheduled every day in this version.
    /// The caller saves the star and any pending completion together.
    @discardableResult
    static func insertIfEarned(in context: ModelContext, on date: Date = .now) throws -> Bool {
        let dayKey = RoutineCompletion.calendarDayKey(for: date)
        var stars = FetchDescriptor<DailyStar>(predicate: #Predicate { $0.dayKey == dayKey })
        stars.fetchLimit = 1
        guard try context.fetch(stars).isEmpty else { return false }

        let required = Set(DailyMission.allCases.map(\.id))
        guard !required.isEmpty else { return false }
        let completions = try context.fetch(FetchDescriptor<RoutineCompletion>(predicate: #Predicate { $0.dayKey == dayKey }))
        let completed = Set(completions.map(\.routineID))
        guard required.isSubset(of: completed) else { return false }
        context.insert(DailyStar(date: date))
        return true
    }
}

import XCTest
import SwiftData
@testable import vacation

final class DailyStarTests: XCTestCase {
    @MainActor
    func testRequiresAllFourAndSurvivesReloadAndMissingDay() throws {
        let container = try ModelContainer(for: RoutineCompletion.self, DailyStar.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = container.mainContext
        let now = Date.now
        for mission in DailyMission.allCases.dropLast() {
            context.insert(RoutineCompletion(routineID: mission.id, date: now))
        }
        XCTAssertFalse(try DailyStarAward.insertIfEarned(in: context, on: now))
        context.insert(RoutineCompletion(routineID: DailyMission.nightPants.id, date: now))
        XCTAssertTrue(try DailyStarAward.insertIfEarned(in: context, on: now))
        XCTAssertFalse(try DailyStarAward.insertIfEarned(in: context, on: now))
        try context.save()
        let fresh = ModelContext(container)
        XCTAssertFalse(try DailyStarAward.insertIfEarned(in: fresh, on: now))
        let original = try XCTUnwrap(fresh.fetch(FetchDescriptor<DailyStar>()).first)
        XCTAssertEqual(original.earnedAt, now)
        let tomorrow = try XCTUnwrap(Calendar.current.date(byAdding: .day, value: 1, to: now))
        XCTAssertFalse(try DailyStarAward.insertIfEarned(in: fresh, on: tomorrow))
        let later = try XCTUnwrap(Calendar.current.date(byAdding: .day, value: 2, to: now))
        for mission in DailyMission.allCases { fresh.insert(RoutineCompletion(routineID: mission.id, date: later)) }
        XCTAssertTrue(try DailyStarAward.insertIfEarned(in: fresh, on: later))
        try fresh.save()
        XCTAssertEqual(try fresh.fetchCount(FetchDescriptor<DailyStar>()), 2)
        // Clearing completions does not remove earned history or create another star.
        for record in try fresh.fetch(FetchDescriptor<RoutineCompletion>()) { fresh.delete(record) }
        try fresh.save()
        XCTAssertFalse(try DailyStarAward.insertIfEarned(in: fresh, on: now))
        XCTAssertEqual(try fresh.fetchCount(FetchDescriptor<DailyStar>()), 2)
    }

    @MainActor
    func testDayUniquenessConstraint() throws {
        let container = try ModelContainer(for: DailyStar.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = container.mainContext
        let now = Date.now
        context.insert(DailyStar(date: now))
        try context.save()
        context.insert(DailyStar(date: now))
        try context.save()
        XCTAssertEqual(try context.fetchCount(FetchDescriptor<DailyStar>()), 1)
    }
}

import XCTest
import SwiftData
@testable import vacation

final class RoutineCompletionTests: XCTestCase {
    @MainActor
    func testHistoryAndUniqueDailyCompletion() throws {
        let container = try ModelContainer(for: RoutineCompletion.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = container.mainContext
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .current
        let today = calendar.startOfDay(for: .now)
        let tomorrow = try XCTUnwrap(calendar.date(byAdding: .day, value: 1, to: today))
        context.insert(RoutineCompletion(routineID: "morningBrush", date: today))
        try context.save()
        context.insert(RoutineCompletion(routineID: "morningBrush", date: today))
        try context.save()
        XCTAssertEqual(try context.fetchCount(FetchDescriptor<RoutineCompletion>()), 1)
        context.insert(RoutineCompletion(routineID: "morningBrush", date: tomorrow))
        context.insert(RoutineCompletion(routineID: "bathTime", date: today))
        try context.save()
        let fresh = ModelContext(container)
        let records = try fresh.fetch(FetchDescriptor<RoutineCompletion>())
        XCTAssertEqual(records.count, 3)
        let todayKey = RoutineCompletion.calendarDayKey(for: today)
        XCTAssertEqual(records.filter { $0.dayKey == todayKey }.count, 2)
        let tomorrowKey = RoutineCompletion.calendarDayKey(for: tomorrow)
        XCTAssertEqual(records.filter { $0.dayKey == tomorrowKey }.count, 1)
        // The DEBUG reset removes only today's history.
        for record in records where record.dayKey == todayKey { fresh.delete(record) }
        try fresh.save()
        let remaining = try fresh.fetch(FetchDescriptor<RoutineCompletion>())
        XCTAssertEqual(remaining.count, 1)
        XCTAssertEqual(remaining.first?.dayKey, tomorrowKey)
    }

    @MainActor
    func testCalendarDaysAcrossDSTAndMidnight() throws {
        let zone = try XCTUnwrap(TimeZone(identifier: "America/New_York"))
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = zone
        for (month, day) in [(3, 8), (11, 1)] {
            let morning = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: month, day: day)))
            let evening = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: month, day: day, hour: 23)))
            let nextDay = try XCTUnwrap(calendar.date(byAdding: .day, value: 1, to: morning))
            XCTAssertEqual(RoutineCompletion.calendarDayKey(for: morning, timeZone: zone), RoutineCompletion.calendarDayKey(for: evening, timeZone: zone))
            XCTAssertNotEqual(RoutineCompletion.calendarDayKey(for: morning, timeZone: zone), RoutineCompletion.calendarDayKey(for: nextDay, timeZone: zone))
        }
    }
}

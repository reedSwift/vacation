import Foundation

enum VacationCountdown {
    /// Calendar boundaries, rather than 24-hour intervals, keep sleeps correct across DST.
    static func sleeps(until startDate: Date, now: Date = .now, calendar: Calendar = VacationSchedule.calendar) -> Int {
        max(0, calendar.dateComponents([.day], from: calendar.startOfDay(for: now), to: calendar.startOfDay(for: startDate)).day ?? 0)
    }
}

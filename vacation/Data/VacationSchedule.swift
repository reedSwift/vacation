import Foundation

enum VacationSchedule {
    // Departure is 8 AM Eastern time, independent of the device's current time zone.
    static var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/New_York")!
        return calendar
    }

    static var departureDate: Date {
        calendar.date(from: DateComponents(year: 2026, month: 10, day: 2, hour: 8))!
    }
}

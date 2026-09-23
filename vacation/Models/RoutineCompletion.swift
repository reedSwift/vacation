import Foundation
import SwiftData

@Model
final class RoutineCompletion {
    // A unique composite key also protects against repeated taps and multiple contexts.
    @Attribute(.unique) var completionKey: String
    var routineID: String
    var dayKey: String
    var completedAt: Date

    init(routineID: String, date: Date = .now) {
        let dayKey = Self.calendarDayKey(for: date)
        self.routineID = routineID
        self.dayKey = dayKey
        self.completionKey = "\(routineID)|\(dayKey)"
        self.completedAt = date
    }

    /// Local civil dates remain stable in history even when the device changes time zone.
    static func calendarDayKey(for date: Date, timeZone: TimeZone = .autoupdatingCurrent) -> String {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        let parts = calendar.dateComponents([.era, .year, .month, .day], from: date)
        return "\(parts.era!)|\(parts.year!)|\(parts.month!)|\(parts.day!)"
    }
}

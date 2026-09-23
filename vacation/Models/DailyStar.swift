import Foundation
import SwiftData

@Model
final class DailyStar {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var dayKey: String
    var calendarDate: Date
    var earnedAt: Date

    init(date: Date = .now) {
        id = UUID()
        dayKey = RoutineCompletion.calendarDayKey(for: date)
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .autoupdatingCurrent
        calendarDate = calendar.startOfDay(for: date)
        earnedAt = date
    }
}

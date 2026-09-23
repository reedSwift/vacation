import Foundation
import SwiftData

@Model
final class PackingItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var emoji: String
    var isPacked: Bool
    var sortOrder: Int
    var trip: Trip?

    init(id: UUID = UUID(), name: String, emoji: String, isPacked: Bool = false, sortOrder: Int, trip: Trip) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.isPacked = isPacked
        self.sortOrder = sortOrder
        self.trip = trip
    }
}

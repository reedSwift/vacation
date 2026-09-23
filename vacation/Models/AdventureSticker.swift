import Foundation
import SwiftData

@Model
final class AdventureSticker {
    @Attribute(.unique) var id: UUID
    var name: String
    var emoji: String
    var isUnlocked: Bool
    var trip: Trip?

    init(id: UUID = UUID(), name: String, emoji: String, isUnlocked: Bool = false, trip: Trip) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.isUnlocked = isUnlocked
        self.trip = trip
    }
}

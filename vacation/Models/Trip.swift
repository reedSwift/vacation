import Foundation
import SwiftData

@Model
final class Trip {
    @Attribute(.unique) var id: UUID
    var name: String
    var destination: String
    var startDate: Date
    var endDate: Date

    @Relationship(deleteRule: .cascade, inverse: \PackingItem.trip)
    var packingItems: [PackingItem] = []

    @Relationship(deleteRule: .cascade, inverse: \AdventureSticker.trip)
    var stickers: [AdventureSticker] = []

    init(id: UUID = UUID(), name: String, destination: String, startDate: Date, endDate: Date) {
        self.id = id
        self.name = name
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
    }
}

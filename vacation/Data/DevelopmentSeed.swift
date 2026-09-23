import Foundation
import SwiftData

@MainActor
enum DevelopmentSeed {
    static func insertIfNeeded(into context: ModelContext) throws {
        var request = FetchDescriptor<Trip>()
        request.fetchLimit = 1
        guard try context.fetch(request).isEmpty else { return }

        let calendar = VacationSchedule.calendar
        let startDate = VacationSchedule.departureDate
        let endDate = calendar.date(byAdding: .day, value: 7, to: startDate)!
        let trip = Trip(
            name: "Our Beach Adventure",
            destination: "The Beach",
            startDate: startDate,
            endDate: endDate
        )
        context.insert(trip)

        let items = [
            ("Swimsuit", "🩱"),
            ("Sunglasses", "🕶️"),
            ("Sand toys", "🪣"),
            ("Favorite toy", "🧸"),
            ("Sandals", "🩴"),
            ("Sun hat", "👒")
        ]
        for (index, item) in items.enumerated() {
            context.insert(PackingItem(name: item.0, emoji: item.1, sortOrder: index, trip: trip))
        }
        context.insert(AdventureSticker(name: "Vacation Scientist", emoji: "🔬", trip: trip))

        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }

    static func updateBeachDepartureIfNeeded(in context: ModelContext) throws {
        let request = FetchDescriptor<Trip>(predicate: #Predicate {
            $0.name == "Our Beach Adventure" && $0.destination == "The Beach"
        })
        for trip in try context.fetch(request) where trip.startDate != VacationSchedule.departureDate {
            let calendar = VacationSchedule.calendar
            let nights = max(0, calendar.dateComponents([.day], from: calendar.startOfDay(for: trip.startDate), to: calendar.startOfDay(for: trip.endDate)).day ?? 7)
            trip.startDate = VacationSchedule.departureDate
            trip.endDate = calendar.date(byAdding: .day, value: nights, to: trip.startDate)!
        }
        if context.hasChanges { try context.save() }
    }

}

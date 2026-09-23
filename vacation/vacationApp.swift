//
//  vacationApp.swift
//  vacation
//
//  Created by Apoorva Reed(Personal) on 9/20/26.
//

import SwiftUI
import SwiftData

@main
struct vacationApp: App {
    private let modelContainer: ModelContainer = {
        do {
            let container = try ModelContainer(for: Trip.self, PackingItem.self, AdventureSticker.self, RoutineCompletion.self, DailyStar.self, RewardUnlock.self)
            #if DEBUG
            try DevelopmentSeed.insertIfNeeded(into: container.mainContext)
            #endif
            try DevelopmentSeed.updateBeachDepartureIfNeeded(in: container.mainContext)
            return container
        } catch {
            fatalError("Unable to initialize vacation data: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}

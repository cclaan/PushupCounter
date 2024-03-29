//
//  PushupCounterApp.swift
//  PushupCounter
//
//  Created by CC Laan on 10/14/23.
//

import SwiftUI
import SwiftData

/*
@main
struct PushupCounterApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            //ContentView()
            PushupCounterView()
        }
        .modelContainer(sharedModelContainer)
    }
}
*/

@main
struct PushupCounterApp: App {
    var body: some Scene {
        WindowGroup {
            //let model = FaceDistanceViewModel()
            //PushupCounterView(viewModel: model )
            PushupCounterView()
        }
        
    }
}

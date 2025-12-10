//
//  HomeHubApp.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 12/10/25.
//

import SwiftUI
import CoreData

@main
struct HomeHubApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

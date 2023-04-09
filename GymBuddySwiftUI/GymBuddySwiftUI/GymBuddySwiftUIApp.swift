//
//  GymBuddySwiftUIApp.swift
//  GymBuddySwiftUI
//
//  Created by Freddie Kohn on 12/03/2023.
//

import SwiftUI

@main
struct GymBuddySwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            //SwiftUIView()
            SwiftView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

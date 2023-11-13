//
//  NotalyApp.swift
//  Notaly
//
//  Created by Ronnie Kissos on 11/13/23.
//

import SwiftUI

@main
struct NotalyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

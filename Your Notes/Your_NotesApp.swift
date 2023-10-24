//
//  Your_NotesApp.swift
//  Your Notes
//
//  Created by Franco Marquez on 16/10/23.
//

import SwiftUI

@main
struct Your_NotesApp: App {
    
    @State private var dataManager = DataManager()
    
    
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environment(\.managedObjectContext, dataManager.container.viewContext)
        }
    }
}

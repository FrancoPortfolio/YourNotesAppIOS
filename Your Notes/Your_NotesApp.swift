//
//  Your_NotesApp.swift
//  Your Notes
//
//  Created by Franco Marquez on 16/10/23.
//

import SwiftUI
import CoreData

@main
struct Your_NotesApp: App {
    
    init() {
        InitialLoadManager.initialColorsSave()
    }
    
    var body: some Scene {
        WindowGroup {
            MainScreen()
        }
    }
}

//
//  DataManager.swift
//  Your Notes
//
//  Created by Franco Marquez on 24/10/23.
//

import Foundation
import CoreData

class DataManager{
    
    static let standard = DataManager()
    
    let container = NSPersistentContainer(name: "AppData")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                Log.error("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}

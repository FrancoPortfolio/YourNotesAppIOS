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
    
    let container = NSPersistentContainer(name: "NoteData")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                Log.error("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func saveData(doWhenDataSaved: () -> () = {}) {
        do {
            try DataManager.standard.container.viewContext.save()
            doWhenDataSaved()
        } catch let error {
            Log.error("Error saving tag: \(error)")
        }
    }

}

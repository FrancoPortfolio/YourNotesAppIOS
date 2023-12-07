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
    var taskContext : NSManagedObjectContext
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                Log.error("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        self.taskContext = container.newBackgroundContext()
        self.taskContext.automaticallyMergesChangesFromParent = true
    }
    
    func saveData(doWhenDataSaved: () -> () = {}) {
        do {
            try DataManager.standard.container.viewContext.save()
            doWhenDataSaved()
        } catch let error {
            Log.error("Error saving tag: \(error)")
        }
    }
    
    func eraseUncommitedChanges(){
        DataManager.standard.container.viewContext.rollback()
    }
}

extension DataManager{
    
    static func getData<T: NSFetchRequestResult>(typeOfEntity: T.Type, entityName: String, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> Array<T>{
        
        let request = NSFetchRequest<T>(entityName: entityName)
        
        var resolve = [T]()
        
        if let predicate = predicate {
            request.predicate = predicate
        }

        if let descriptors = sortDescriptors{
            request.sortDescriptors = descriptors
        }
        
        do {
            Log.info("Fetching items of type: \(typeOfEntity)")
            resolve = try self.standard.container.viewContext.fetch(request)
            Log.info("Items of type \(typeOfEntity) fetched")
        } catch {
            Log.error("Error trying to fetch items of type: \(typeOfEntity)")
        }
        
        return resolve
    }
    
    static func getFirstData<T: NSFetchRequestResult>(typeOfEntity: T.Type, entityName: String, predicate: NSPredicate? = nil) -> T?{
        let data = getData(typeOfEntity: typeOfEntity, entityName: entityName, predicate: predicate)
        if let value = data.first{
            return value
        }
        return nil
    }
    
    static func turnSetToArray<T:NSFetchRequestResult>(set: NSSet?, typeToConvert: T.Type ) -> Array<T>?{
        
        guard let set = set else {return nil}
        
        guard let array = set.allObjects as? [T] else {
            Log.error("No possible to convert to array of \(typeToConvert)")
            return nil
        }
        
        return array
    }
}

extension DataManager{
    static func getData<T: NSFetchRequestResult>(typeOfEntity: T.Type,
                                                 entityName: String,
                                                 predicate: NSPredicate? = nil,
                                                 sortDescriptors: [NSSortDescriptor]? = nil,
                                                 doWhenFetchEnded: @escaping (Array<T>) -> ()){
        
        DataManager.standard.taskContext.perform {
            let request = NSFetchRequest<T>(entityName: entityName)
            
            if let predicate = predicate {
                request.predicate = predicate
            }
            
            if let descriptors = sortDescriptors{
                request.sortDescriptors = descriptors
            }
            
            request.fetchLimit = 5
            
            do {
                Log.info("Fetching items of type: \(typeOfEntity)")
                let resolve = try self.standard.container.viewContext.fetch(request)
                Log.info("Items of type \(typeOfEntity) fetched")
                doWhenFetchEnded(resolve)
            } catch {
                Log.error("Error trying to fetch items of type: \(typeOfEntity)")
            }
        }
    }
    
    static func deleteObject<T: NSManagedObject>(object: T, save: Bool = false){
        DataManager.standard.container.viewContext.delete(object)
        if save{
            DataManager.standard.saveData()
        }
    }
}

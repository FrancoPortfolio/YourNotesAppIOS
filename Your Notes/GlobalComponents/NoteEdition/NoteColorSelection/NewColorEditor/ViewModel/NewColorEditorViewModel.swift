//
//  NewColorEditorViewModel.swift
//  Your Notes
//
//  Created by Franco Marquez on 25/10/23.
//

import Foundation
import CoreData

class NewColorEditorViewModel: ObservableObject{
    
    @Published var showAlertOfExistingColor: Bool = false
    
    func checkIfColorExists(colorHex: String?) -> Bool{
        
        if let color = colorHex{
            
            let predicate = NSPredicate(
                format: "colorHex LIKE %@", color
            )
            
            let fetchRequest = NoteHighlightColor.fetchRequest()
            fetchRequest.predicate = predicate
            
            do {
                let objects = try DataManager.standard.container.viewContext.fetch(fetchRequest)
                Log.info("Objects: \(objects)")
                if objects.isEmpty{
                    return false
                } else {
                    return true
                }
            } catch {
                Log.error("\(error.localizedDescription)")
            }
            
        }
        return true
    }
    
    func saveColorOnCoreData(colorHex: String?){
        
        guard let color = colorHex else{
            return
        }
        
        if checkIfColorExists(colorHex: color){
            self.showAlertOfExistingColor = true
            return
        }
        
        saveNewColor(colorHex: color)
    }
    
    private func saveNewColor(colorHex: String){
        let newTagEntity = NoteHighlightColor(context:  DataManager.standard.container.viewContext)
        newTagEntity.id = UUID().uuidString
        newTagEntity.colorHex = colorHex
        saveColorData()
    }
    
    private func saveColorData() {
        do {
            Log.info("Saving colors on core data")
            try DataManager.standard.container.viewContext.save()
        } catch {
            Log.error("Error saving tag: \(error)")
        }
    }
    
    
}

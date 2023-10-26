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
                if objects.isEmpty{
                    Log.info("No color on Core Data")
                    return false
                } else {
                    Log.warning("Color found on Core Data")
                    return true
                }
            } catch {
                Log.error("\(error.localizedDescription)")
            }
            
        }
        return true
    }
    
    func saveColorOnCoreData(colorHex: String?, doWhenSavingDone: ()->() = {}){
        
        guard let color = colorHex else{
            Log.warning("Bad color hex")
            return
        }
        
        if checkIfColorExists(colorHex: color){
            self.showAlertOfExistingColor = true
            return
        }
        
        saveNewColor(colorHex: color){
            doWhenSavingDone()
        }
    }
    
    private func saveNewColor(colorHex: String,doWhenSavingDone: ()->() = {}){
        let newTagEntity = NoteHighlightColor(context:  DataManager.standard.container.viewContext)
        newTagEntity.id = UUID().uuidString
        newTagEntity.colorHex = colorHex
        DataManager.standard.saveData(){
            doWhenSavingDone()
        }
    }
    
}

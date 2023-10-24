//
//  NewNoteColorSectionViewModel.swift
//  Your Notes
//
//  Created by Franco Marquez on 24/10/23.
//

import Foundation
import CoreData

class NewNoteColorSectionViewModel: ObservableObject{
    
    @Published var highlightColors = [NoteHighlightColor]()
    
    func getColors(){
        let request = NSFetchRequest<NoteHighlightColor>(entityName: "NoteHighlightColor")
        
        do {
            Log.info("Fetching Colors")
            try highlightColors = DataManager.standard.container.viewContext.fetch(request)
            Log.info("Colors fetched")
        } catch  {
            Log.error("Error getting tag data: \(error.localizedDescription)")
        }
    }
    
    func saveNewColor(colorHex: String){
        let newTagEntity = NoteHighlightColor(context:  DataManager.standard.container.viewContext)
        newTagEntity.id = UUID().uuidString
        newTagEntity.colorHex = colorHex
        saveColorData()
    }
    
    func saveColorData() {
        do {
            Log.info("Saving colors on core data")
            try DataManager.standard.container.viewContext.save()
            getColors()
        } catch let error {
            Log.error("Error saving tag: \(error)")
        }
    }

}

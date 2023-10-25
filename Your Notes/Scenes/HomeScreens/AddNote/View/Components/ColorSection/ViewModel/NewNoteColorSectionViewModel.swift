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
    
    init(){
        getColors()
    }
    
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

}

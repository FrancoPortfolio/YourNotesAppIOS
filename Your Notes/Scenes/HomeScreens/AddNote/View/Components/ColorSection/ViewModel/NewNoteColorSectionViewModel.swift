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
        
        self.highlightColors = DataManager.getData(typeOfEntity: NoteHighlightColor.self, entityName: "NoteHighlightColor")
    }

}

//
//  TagSectionNewNoteViewModel.swift
//  Your Notes
//
//  Created by Franco Marquez on 24/10/23.
//

import Foundation
import CoreData

class NewNoteTagSectionViewViewModel: ObservableObject{
    
    @Published var tags = [NoteTag]()
    
    init(){
        getTagData()
    }
    
    func getTagData(){
        let request = NSFetchRequest<NoteTag>(entityName: "NoteTag")
        
        do {
            try tags = DataManager.standard.container.viewContext.fetch(request)
        } catch  {
            Log.error("Error getting tag data: \(error.localizedDescription)")
        }
    }
    
    func saveNewTag(tagName: String){
        let newTagEntity = NoteTag(context:  DataManager.standard.container.viewContext)
        newTagEntity.id = UUID()
        newTagEntity.tag = tagName
        DataManager.standard.saveData(){
            getTagData()
        }
    }
    
}

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
        tags = DataManager.getData(typeOfEntity: NoteTag.self, entityName: "NoteTag")
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

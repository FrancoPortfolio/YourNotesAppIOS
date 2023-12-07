//
//  HomeViewModel.swift
//  Your Notes
//
//  Created by Franco Marquez on 25/10/23.
//

import Foundation
import CoreData


class HomeViewModel: ObservableObject{
    
    @Published var searchText = ""
    @Published var showFavorites = false
    @Published var sortBy : NotesSorting = .dateAddedNewer
    @Published var firstColumnArray = [Note]()
    @Published var secondColumnArray = [Note]()
    private var notes = [Note]()
    
    func getAllNoteData(){
        let sortDescriptors = getDescriptors()
        
        var predicate = getPredicate()
        
        print(predicate)
        
        self.notes = DataManager.getData(typeOfEntity: Note.self,
                                         entityName: "Note",
                                         predicate: predicate,
                                         sortDescriptors: sortDescriptors)
        self.setupColumns()
    }
    
    private func getDescriptors() -> [NSSortDescriptor]{
        let pinnedDescriptor = NSSortDescriptor(key: "isPinned", ascending: false)
        var sortDescriptors : [NSSortDescriptor] = [pinnedDescriptor]
        sortDescriptors.append(sortBy.descriptor)
        return sortDescriptors
    }
    
    private func getPredicate(stringSearch: String? = nil) -> NSPredicate?{
        
        var predicates: [NSPredicate] = []
        
        if showFavorites{
            predicates.append(NSPredicate(format: "isFavorite == true"))
        }
        
        if self.searchText != ""{
            predicates.append(NSPredicate(format: "tag.tag CONTAINS[c] %@", searchText))
        }
        
        print(predicates)
        
        var predicate: NSPredicate? = nil
        
        if !predicates.isEmpty{
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        
        return predicate
    }
    
    private func setupColumns(){
        firstColumnArray = []
        secondColumnArray = []
        for index in 0..<notes.count{
            if index.isMultiple(of: 2){
                firstColumnArray.append(notes[index])
                continue
            }
            secondColumnArray.append(notes[index])
        }
    }
}

//Favorites and Pin management
extension HomeViewModel{
    
    func markAsFavorite(note: Note){
        note.isFavorite = true
        DataManager.standard.saveData(){
            getAllNoteData()
        }
    }
    
    func markAsPinned(note: Note){
        note.isPinned = true
        DataManager.standard.saveData(){
            getAllNoteData()
        }
    }
    
    func unmarkAsFavorite(note: Note){
        note.isFavorite = false
        DataManager.standard.saveData(){
            getAllNoteData()
        }
    }
    
    func unmarkAsPinned(note: Note){
        note.isPinned = false
        DataManager.standard.saveData(){
            getAllNoteData()
        }
    }
}

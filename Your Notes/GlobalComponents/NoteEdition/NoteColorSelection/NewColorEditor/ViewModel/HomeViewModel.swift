//
//  HomeViewModel.swift
//  Your Notes
//
//  Created by Franco Marquez on 25/10/23.
//

import Foundation
import CoreData

class HomeViewModel: ObservableObject{
    
    @Published var firstColumnArray = [Note]()
    @Published var secondColumnArray = [Note]()
    private var notes = [Note]()
    
    func getAllNoteData(descriptors: [NSSortDescriptor]? = nil, predicate: NSPredicate? = nil){
        let pinnedDescriptor = NSSortDescriptor(key: "isPinned", ascending: false)
        var sortDescriptors : [NSSortDescriptor] = [pinnedDescriptor]
        if let descriptors{
            sortDescriptors = sortDescriptors + descriptors
        }
        notes = DataManager.getData(typeOfEntity: Note.self, entityName: "Note",predicate: predicate,sortDescriptors: sortDescriptors)
        setupColumns()
    }
    
    func getFavoritesNoteData(sortCriteria: NotesSorting = .dateAddedNewer){
        let predicate = NSPredicate(format: "isFavorite == true")
        let sortCriteria = sortCriteria.descriptor
        self.getAllNoteData(descriptors: [sortCriteria],predicate: predicate)
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
    
    func sortNotes(sortCriteria: NotesSorting = .dateAddedNewer){
        let sortCriteria = sortCriteria.descriptor
        getAllNoteData(descriptors: [sortCriteria])
    }
    
}

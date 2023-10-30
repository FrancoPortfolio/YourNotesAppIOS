//
//  HomeViewModel.swift
//  Your Notes
//
//  Created by Franco Marquez on 25/10/23.
//

import Foundation
import CoreData

class HomeViewModel: ObservableObject{
    
    @Published var notes = [Note]()
    
    func getNoteData(){
        notes = DataManager.getData(typeOfEntity: Note.self, entityName: "Note")
    }
    
}

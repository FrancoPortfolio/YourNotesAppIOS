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
    
    init(){
        
    }
    
    func getNoteData(){
        let request = NSFetchRequest<Note>(entityName: "Note")
        
        do {
            try notes = DataManager.standard.container.viewContext.fetch(request)
        } catch  {
            Log.error("Error getting notes: \(error.localizedDescription)")
        }
    }
    
}

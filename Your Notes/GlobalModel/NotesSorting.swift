//
//  NotesSorting.swift
//  Your Notes
//
//  Created by Franco Marquez on 26/10/23.
//

import Foundation

enum NotesSorting: String, CaseIterable, Identifiable{
    case dateAddedNewer
    case dateAddedOldest
    case dateChangedNewer
    case dateChangedOldest
    var id: Self {return self}
    
    var title: String {
        switch self {
        case .dateChangedNewer:
            return "By date changed(Newest)"
        case .dateAddedNewer:
            return "By date added(Newest)"
        case .dateChangedOldest:
            return "By date changed(Oldest)"
        case .dateAddedOldest:
            return "By date added(Oldest)"
        }
    }
    
    var descriptor: NSSortDescriptor{
        switch self{
        case .dateAddedNewer:
            return NSSortDescriptor(key: "dateCreated", ascending: false)
        case .dateAddedOldest:
            return NSSortDescriptor(key: "dateCreated", ascending: true)
        case .dateChangedNewer:
            return NSSortDescriptor(key: "dateModified", ascending: false)
        case .dateChangedOldest:
            return NSSortDescriptor(key: "dateModified", ascending: true)
        }
    }
}

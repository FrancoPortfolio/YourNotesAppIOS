//
//  HomeRoutingDestinations.swift
//  Your Notes
//
//  Created by Franco Marquez on 17/10/23.
//

import Foundation

enum HomeRoutingDestinations: Hashable{
    
    case newNote
    case editNote
    case expandNote(noteId: String)
    
}

enum AddNoteDestinations: Hashable {
    case image
    case camera
    case voiceNote
    case drawing
}

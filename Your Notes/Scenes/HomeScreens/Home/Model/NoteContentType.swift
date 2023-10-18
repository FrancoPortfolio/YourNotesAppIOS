//
//  NoteContentType.swift
//  Your Notes
//
//  Created by Franco Marquez on 16/10/23.
//

import Foundation
enum NoteContentType: String, CaseIterable, Identifiable, Codable{
    
    case PlainText
    case ToDo
    case Image
    case Voice
    case Drawing
    
    var id: Self {return self}
    
    var title: String{
        switch self {
        case .PlainText:
            return "Text"
        case .ToDo:
            return "To-Do"
        case .Image:
            return "Image/Photo"
        case .Voice:
            return "Voice Message"
        case .Drawing:
            return "Drawn Notes"
        }
    }
}

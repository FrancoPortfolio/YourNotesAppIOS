//
//  Note.swift
//  Your Notes
//
//  Created by Franco Marquez on 16/10/23.
//

import Foundation

struct Note: Codable, Hashable{
    
    var id: String = UUID().uuidString
    var title: String
    var isFavorite: Bool
    var highlightColor: String = "#FFFFFF"
    var isClassified: Bool
    var classTag: ClassTag?
    var isPinned: Bool
    var dateAdded: Date = Date()
    var dateCreated: Date = Date()
    var contentTypes: [NoteContentType]
    var noteData: NoteData = NoteData()
    
//    static var NoteMockup1 = Note(title: "MyNote1",
//                                 isFavorite: false,
//                                 highlightColor: "#FFFAAA",
//                                 isClassified: false, 
//                                 classTag: nil,
//                                  isPinned: false,
//                                 contentTypes: [.PlainText])
//    
//    static var NoteMockup2 = Note(title: "MyNote2",
//                                 isFavorite: true,
//                                 highlightColor: "#ABCDEF",
//                                 isClassified: false,
//                                 classTag: nil,
//                                  isPinned: false,
//                                  contentTypes: [.PlainText,.Image])
//    
//    static var NoteMockup3 = Note(title: "MyNote3",
//                                 isFavorite: false,
//                                 highlightColor: "#FF33AA",
//                                 isClassified: true,
//                                 classTag: "#home",
//                                  isPinned: true,
//                                 contentTypes: [.Image,.Voice])
//    
//    static var NoteMockup4 = Note(title: "MyNote4",
//                                 isFavorite: false,
//                                 highlightColor: "#123556",
//                                 isClassified: false,
//                                 classTag: nil,
//                                  isPinned: false,
//                                 contentTypes: [.Drawing,.Image])
//    
    static var NoteMockup5 = Note(title: "MyNote5",
                                 isFavorite: true,
                                 highlightColor: "#FFFAAA",
                                 isClassified: false,
                                 classTag: nil,
                                  isPinned: false,
                                 contentTypes: [.PlainText,.Voice],
                                noteData: NoteData(
                                    textData: "Lista de compras me gusta el pollo frito de KFC ojala comer mas gaaaaaaaaaaaaa",
                                    voiceData: "Prueba1.m4a"
                                ))
//    
//    static var NoteMockup6 = Note(title: "MyNote6",
//                                 isFavorite: true,
//                                 highlightColor: "#FFFAAA",
//                                 isClassified: true,
//                                 classTag: "#hate",
//                                  isPinned: false,
//                                 contentTypes: [.PlainText,.Image,.Voice,.ToDo,.Drawing])
//    
//    static var NoteMockupArray = [NoteMockup1,
//                                  NoteMockup2,
//                                  NoteMockup3,
//                                  NoteMockup4,
//                                  NoteMockup5,
//                                  NoteMockup6]
    
}

struct NoteData: Codable, Hashable{
    var textData: String?
    var toDoData: [Subtask]?
    var imageData: String?
    var voiceData: String?
    var drawingData: String?
}

struct Subtask: Codable, Hashable, Identifiable{
    var id = UUID()
    var name: String
    var isChecked: Bool
}

struct ClassTag: Codable, Hashable, Identifiable{
    var id = UUID()
    var tag: String
}


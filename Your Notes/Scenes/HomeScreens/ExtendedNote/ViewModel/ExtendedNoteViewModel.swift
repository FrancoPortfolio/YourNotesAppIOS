//
//  ExtendedNoteViewModel.swift
//  Your Notes
//
//  Created by Franco Marquez on 7/11/23.
//

import Foundation
import UIKit

class ExtendedNoteViewModel: ObservableObject{
    
    var note: Note?
    var noteId: String
    @Published var title: String = ""
    @Published var bodyText: String = ""
    @Published var subtasks: [NoteSubtask]? = nil
    @Published var images: [UIImage] = []
    @Published var recordings: [NoteVoicenote] = []
    
    init(noteId: String){
        self.noteId = noteId
        initialDataLoad()
    }
    
    func changeStateSubtask(subtask: NoteSubtask){
        subtask.isDone.toggle()
        DataManager.standard.saveData(){
            self.initialDataLoad()
        }
    }
    
    private func initialDataLoad(){
        let id = UUID(uuidString: self.noteId)!
        
        let predicate = NSPredicate(
            format: "id == %@", id as CVarArg
        )
        
        if let note = DataManager.getFirstData(typeOfEntity: Note.self, entityName: "Note", predicate: predicate){
            self.note = note
            setupMedia()
        }
    }
    
    private func setupMedia(){
        guard let finalNote = self.note else{
            return
        }
        
        if var subtaskArray = DataManager.turnSetToArray(set: finalNote.subtasks, typeToConvert: NoteSubtask.self){
            subtaskArray = subtaskArray.sorted(by: { subtask1, subtask2 in  subtask1.dateCreated!.compare(subtask2.dateCreated!) == .orderedAscending })
            self.subtasks = subtaskArray
            
        }
        
        if let title = finalNote.title{
            self.title = title
        }
        
        if let text = finalNote.text{
            self.bodyText = text
        }
        
        if let images = DataManager.turnSetToArray(set: finalNote.images, typeToConvert: NoteImage.self){
            for image in images {
                if let data = image.imageData, let uiImage = UIImage(data: data){
                    self.images.append(uiImage)
                }
            }
        }
        
        if let recordings = DataManager.turnSetToArray(set: finalNote.voicenotes, typeToConvert: NoteVoicenote.self){
            self.recordings = recordings
        }
    }
}

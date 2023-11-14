//
//  ExtendedNoteViewModel.swift
//  Your Notes
//
//  Created by Franco Marquez on 7/11/23.
//

import Foundation
import UIKit
import SwiftUI

class ExtendedNoteViewModel: ObservableObject{
    
    var note: Note?
    var noteId: String
    
    @Published var screenMode = ScreenMode.display
    
    @Published var isSaving = false
    
    @Published var title: String = ""
    
    @Published var bodyText: String = ""
    
    @Published var subtasks: [NoteSubtask]? = nil
    
    @Published var images: [NoteImage] = []
    
    @Published var recordings: [NoteVoicenote] = []
    
    var temporalRecording = [String]()
    
    @Published var drawing: NoteDrawing? = nil
    @Published var drawingData: Data = Data()
    
    @Published var isPinned = false
    @Published var isFavorite = false
    
    private var initialData = InitialValues()
    
    init(noteId: String){
        self.noteId = noteId
        initialDataLoad()
    }
    
}

//initial handlers
extension ExtendedNoteViewModel{
    private func setupSubtasks(){
        if let finalNote = self.note{
            if var subtaskArray = DataManager.turnSetToArray(set: finalNote.subtasks, typeToConvert: NoteSubtask.self){
                subtaskArray = subtaskArray.sorted(by: { subtask1, subtask2 in  subtask1.dateCreated!.compare(subtask2.dateCreated!) == .orderedAscending })
                self.subtasks = subtaskArray
                self.initialData.initialSubtasks = finalNote.subtasks
            }else{
                self.initialData.initialSubtasks = nil
            }
        }
    }
    
    private func setupTitle(){
        if let finalNote = self.note{
            if let title = finalNote.title{
                self.title = title
                self.initialData.initalTitle = title
            }
        }
    }
    
    private func setupText(){
        if let finalNote = self.note{
            if let text = finalNote.text{
                self.bodyText = text
                self.initialData.initialBodyText = text
            }
        }
    }
    
    private func setupImages(){
        if let finalNote = self.note{
                if let images = DataManager.turnSetToArray(set: finalNote.images, typeToConvert: NoteImage.self){
                    self.images = images
                    self.initialData.initialImages = finalNote.images
                }
        }
    }
    
    private func setupRecordings(){
        if let finalNote = self.note{
            if let recordings = DataManager.turnSetToArray(set: finalNote.voicenotes, typeToConvert: NoteVoicenote.self){
                Log.info("\(recordings)")
                self.recordings = recordings
                self.initialData.initialVoicenotes = finalNote.voicenotes
            }
        }
    }
    
    private func setupDrawingImage(){
        if let finalNote = self.note, let drawingData = finalNote.drawing?.drawingData{
            self.drawing = finalNote.drawing
            self.drawingData = drawingData
            self.initialData.initialDrawing = finalNote.drawing
        }
    }
}

//subtasks handlers
extension ExtendedNoteViewModel{
    
    func changeStateSubtask(subtask: NoteSubtask, isEditing: Bool = false){
        subtask.isDone.toggle()
        if !isEditing{
            DataManager.standard.saveData(){
                self.reloadSubtasks()
            }
        }
    }
    
    private func reloadSubtasks(){
        
        let predicate = NSPredicate(
            format: "note.id == %@", noteId as CVarArg
        )
        
        DataManager.getData(
            typeOfEntity: NoteSubtask.self,
            entityName: "NoteSubtask",
            predicate: predicate) { array in
                let subtasks = self.orderSubtaskArray(subtasks: array)
                DispatchQueue.main.async {
                    self.subtasks = subtasks
                }
            }
    }
    
    private func orderSubtaskArray(subtasks: Array<NoteSubtask>) -> Array<NoteSubtask>{
        return subtasks.sorted(by: { subtask1, subtask2 in  subtask1.dateCreated!.compare(subtask2.dateCreated!) == .orderedAscending })
    }
}

//image handlers
extension ExtendedNoteViewModel{
    func eraseImageFromArrayTemp(noteImage: NoteImage){
        
        if let indexToRemove = self.images.firstIndex(of: noteImage){
            DataManager.standard.container.viewContext.delete(self.images[indexToRemove])
            withAnimation(.linear){
               let _ = self.images.remove(at: indexToRemove)
            }
        }
    }
}

//manage saving and loading
extension ExtendedNoteViewModel{
    func reloadInitialValues(){
        DataManager.standard.eraseUncommitedChanges()
        initialDataLoad()
    }
    
    
    private func initialDataLoad(){
        let id = UUID(uuidString: self.noteId)!
        
        let predicate = NSPredicate(
            format: "id == %@", id as CVarArg
        )
        
        if let note = DataManager.getFirstData(typeOfEntity: Note.self, entityName: "Note", predicate: predicate){
            self.note = note
            self.initialData.note = note
            self.isPinned = note.isPinned
            self.isFavorite = note.isFavorite
            setupMedia()
        }
    }
    
    private func setupMedia(){
        setupSubtasks()
        setupTitle()
        setupText()
        setupImages()
        setupRecordings()
        setupDrawingImage()
    }
    
    func saveAllData(){
        self.isSaving = true
        note?.text = self.bodyText
        note?.title = self.title
        for image in self.images{
            image.note = self.note
        }
        if let subtasks = self.subtasks{
            for subtask in subtasks{
                subtask.note = self.note
            }
        }
        for voiceNote in self.recordings{
            voiceNote.note = self.note
        }
        
        if self.drawing != nil{
            let drawing = NoteDrawing(context: DataManager.standard.container.viewContext)
            drawing.note = note
            drawing.drawingData = self.drawingData
            drawing.id = UUID()
        }else{
            note?.drawing = nil
        }
        note?.dateModified = Date()
        DataManager.standard.saveData{
            self.isSaving = false
            self.initialDataLoad()
            withAnimation(){
                self.screenMode = .display
            }
        }
    }
    
}
//pin and favorite
extension ExtendedNoteViewModel{
    func markAsFavorite(){
        if let note = self.note{
            note.isFavorite = true
            DataManager.standard.saveData{
                self.isFavorite = true
            }
        }
    }
    
    func markAsPinned(){
        if let note = self.note{
            note.isPinned = true
            DataManager.standard.saveData{
                self.isPinned = true
            }
        }
    }
    
    func unmarkAsFavorite(){
        if let note = self.note{
            note.isFavorite = false
            DataManager.standard.saveData{
                self.isFavorite = false
            }
        }
    }
    
    func unmarkAsPinned(){
        if let note = self.note{
            note.isPinned = false
            DataManager.standard.saveData{
                self.isPinned = false
            }
        }
    }
}

fileprivate class InitialValues{
    var note : Note?
    var initalTitle = ""
    var initialBodyText = ""
    var initialImages : NSSet? = nil
    var initialVoicenotes: NSSet? = nil
    var initialDrawing: NoteDrawing? = nil
    var initialSubtasks: NSSet? = nil
}



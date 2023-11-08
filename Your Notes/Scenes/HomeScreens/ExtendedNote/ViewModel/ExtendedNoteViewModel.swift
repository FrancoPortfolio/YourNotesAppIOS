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
    @Published var drawingImage: UIImage? = nil
    
    init(noteId: String){
        self.noteId = noteId
        initialDataLoad()
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
        setupSubtasks()
        setupTitle()
        setupText()
        setupImages()
        setupRecordings()
        setupDrawingImage()
    }
}

//initial handlers
extension ExtendedNoteViewModel{
    private func setupSubtasks(){
        if let finalNote = self.note{
            if var subtaskArray = DataManager.turnSetToArray(set: finalNote.subtasks, typeToConvert: NoteSubtask.self){
                subtaskArray = subtaskArray.sorted(by: { subtask1, subtask2 in  subtask1.dateCreated!.compare(subtask2.dateCreated!) == .orderedAscending })
                self.subtasks = subtaskArray
            }
        }
    }
    
    private func setupTitle(){
        if let finalNote = self.note{
            if let title = finalNote.title{
                self.title = title
            }
        }
    }
    
    private func setupText(){
        if let finalNote = self.note{
            if let text = finalNote.text{
                self.bodyText = text
            }
        }
    }
    
    private func setupImages(){
        if let finalNote = self.note{
                if let images = DataManager.turnSetToArray(set: finalNote.images, typeToConvert: NoteImage.self){
                    var imageArray = [UIImage]()
                    for image in images {
                        if let data = image.imageData, let uiImage = UIImage(data: data){
                           imageArray.append(uiImage)
                        }
                    }
                    self.images = imageArray
                }
        }
    }
    
    private func setupRecordings(){
        if let finalNote = self.note{
            if let recordings = DataManager.turnSetToArray(set: finalNote.voicenotes, typeToConvert: NoteVoicenote.self){
                self.recordings = recordings
            }
        }
    }
    
    private func setupDrawingImage(){
        if let finalNote = self.note, let drawingData = finalNote.drawing?.drawingData{
            let drawingImage = UIImage.getUIImageFromCanvasData(data: drawingData)
            self.drawingImage = drawingImage
        }
    }
}

//subtasks handlers
extension ExtendedNoteViewModel{
    
    
    
    func changeStateSubtask(subtask: NoteSubtask){
        subtask.isDone.toggle()
        DataManager.standard.saveData(){
            self.reloadSubtasks()
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



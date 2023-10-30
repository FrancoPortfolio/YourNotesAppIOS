//
//  AddNoteViewModel.swift
//  Your Notes
//
//  Created by Franco Marquez on 18/10/23.
//

import Foundation
import CoreData
import UIKit

@MainActor
class AddNewNoteViewModel: ObservableObject{
    
    @Published var noteId: String = UUID().uuidString
    @Published var noteTagId: UUID? = nil
    @Published var noteText: String = ""
    @Published var selectedColorId: String = "d6eeb4b3-d8ac-4fc2-a58d-85a5475d6cd6"
    @Published var audioFilesUrlStrings: [String] = []
    @Published var subtasks: [Subtask] = []
    @Published var drawingData: Data?
    @Published var imagesToShow: [UIImage] = []
    @Published var tempSubtaskText: String = ""
    
    @Published var presentNoDataAlert = false
    
    func saveNote(doWhenDataSaved: () -> () = {}){
        
        if !checkIfShouldSave(){
            Log.warning("No data to save, show alert")
            self.presentNoDataAlert.toggle()
            return
        }
        
        let noteEntity = Note(context: DataManager.standard.container.viewContext)
        noteEntity.text = noteText
        noteEntity.id = UUID()
        noteEntity.dateCreated = Date()
        noteEntity.dateModified = Date()
        noteEntity.isPinned = false
        noteEntity.isFavorite = false
        noteEntity.color = getColorEntity()
        noteEntity.tag = getTagEntity()
        noteEntity.images = getImagesEntities()
        noteEntity.voicenotes = getVoiceNotesEntities()
        noteEntity.drawing = getDrawingEntity()
        noteEntity.subtasks = getSubtaskEntities()
        
        DataManager.standard.saveData(){
            doWhenDataSaved()
        }
        
    }
    
    private func getColorEntity() -> NoteHighlightColor?{
        
        let predicate = NSPredicate(
            format: "id LIKE %@", selectedColorId
        )
        return DataManager.getFirstData(typeOfEntity: NoteHighlightColor.self, entityName: "NoteHighlightColor", predicate: predicate)
    }
    
    private func getTagEntity() -> NoteTag?{
        
        guard let tagId = noteTagId else { return nil }
        
        let predicate = NSPredicate(
            format: "id == %@", tagId as CVarArg
        )
        
        return DataManager.getFirstData(typeOfEntity: NoteTag.self, entityName: "NoteTag",predicate: predicate)
    }
    
    private func getImagesEntities() -> NSSet?{
        
        if imagesToShow.isEmpty{
            Log.info("No images to save")
            return nil
        }
        
        var tempImageDataSet = Set<NoteImage>()
        
        for img in imagesToShow{
            
            if let imgData = img.jpegData(compressionQuality: 0.125){
                
                let noteImgEntity = NoteImage(context: DataManager.standard.container.viewContext)
                
                noteImgEntity.id = UUID()
                noteImgEntity.imageData = imgData
                
                tempImageDataSet.insert(noteImgEntity)
            }
            
        }
        
        return NSSet(set: tempImageDataSet)
    }
    
    private func getVoiceNotesEntities() -> NSSet?{
        
        if audioFilesUrlStrings.isEmpty{
            Log.info("No audios to save")
            return nil
        }
        
        var tempVoicenotesDirectorySet = Set<NoteVoicenote>()
        
        for directory in audioFilesUrlStrings{
                
                let noteVoiceNoteEntity = NoteVoicenote(context: DataManager.standard.container.viewContext)
                
                noteVoiceNoteEntity.id = UUID()
                noteVoiceNoteEntity.voiceNoteDirectory = directory
                
                tempVoicenotesDirectorySet.insert(noteVoiceNoteEntity)
            
        }
        
        return NSSet(set: tempVoicenotesDirectorySet)
    }
    
    private func getDrawingEntity() -> NoteDrawing?{
        
        guard let data = self.drawingData else {
            return nil
        }
        
        let drawingEntity = NoteDrawing(context: DataManager.standard.container.viewContext)
        
        drawingEntity.drawingData = data
        drawingEntity.id = UUID()
        
        return drawingEntity
    }
    
    private func getSubtaskEntities() -> NSSet?{
        
        if self.subtasks.isEmpty{
            Log.info("No subtasks to save")
            return nil
        }
        
        var tempSubtasksSet = Set<NoteSubtask>()
        
        for task in subtasks{
            
            let subtaskEntity = NoteSubtask(context: DataManager.standard.container.viewContext)
            
            subtaskEntity.id = UUID()
            subtaskEntity.isDone = task.isChecked
            subtaskEntity.task = task.name
            subtaskEntity.dateCreated = Date()
            
            tempSubtasksSet.insert(subtaskEntity)
        }
        
        return NSSet(set: tempSubtasksSet)
    }
    
    private func checkIfShouldSave() -> Bool{
        
        let isThereText = !noteText.isEmpty
        
        let isThereImages = !imagesToShow.isEmpty
        
        let isThereVoiceNotes = !audioFilesUrlStrings.isEmpty
        
        let isThereSubtasks = !subtasks.isEmpty
        
        let isThereDrawing = drawingData != nil
        
        return isThereText || isThereImages || isThereDrawing || isThereSubtasks || isThereVoiceNotes
        
    }
}

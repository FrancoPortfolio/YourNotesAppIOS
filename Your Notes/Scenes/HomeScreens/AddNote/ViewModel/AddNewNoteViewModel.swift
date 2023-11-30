//
//  AddNoteViewModel.swift
//  Your Notes
//
//  Created by Franco Marquez on 18/10/23.
//

import Foundation
import CoreData
import UIKit
import SwiftUI

@MainActor
class AddNewNoteViewModel: ObservableObject{
    
    @Published var noteId: String = UUID().uuidString
    @Published var noteTagId: UUID? = nil
    @Published var noteText: String = ""
    @Published var noteTitle: String = ""
    
    @Published var selectedColorId: String = "d6eeb4b3-d8ac-4fc2-a58d-85a5475d6cd6"
    
    @Published var audioNotes: [NoteVoicenote] = []
    
    @Published var subtasks: [Subtask] = []
    
    @Published var drawingDataDisplay: Data?
    @Published var noteDrawingTemp: NoteDrawing? = nil
    
    @Published var imagesToShow: [UIImage] = []
    
    @Published var tempSubtaskText: String = ""
    
    @Published var tempImageCamera : UIImage? = nil
    
    @Published var presentNoDataAlert = false
    
    @Published var isSaving = false
    
    func saveNote(doWhenDataSaved: () -> () = {}){
        
        if !checkIfShouldSave() {
            presentNoDataAlert.toggle()
            return
        }
        
        isSaving = true
        
        let noteEntity = Note(context: DataManager.standard.container.viewContext)
        
        basicDataLinkingNote(note: noteEntity)
        
        linkImagesToNote(note: noteEntity)
        
        linkColorToNote(note: noteEntity)
        
        linkTagToEntity(note: noteEntity)
        
        linkVoiceNotesToNoteEntity(noteEntity: noteEntity)
        
        linkSubtasksToNote(note: noteEntity)
        
        linkDrawingToImage(note: noteEntity)
        
        DataManager.standard.saveData(){
            self.isSaving = true
            doWhenDataSaved()
        }
        
    }
    
    private func basicDataLinkingNote(note noteEntity: Note){
        noteEntity.text = noteText
        noteEntity.title = noteTitle
        noteEntity.id = UUID(uuidString: noteId)
        noteEntity.dateCreated = Date()
        noteEntity.dateModified = Date()
        noteEntity.isPinned = false
        noteEntity.isFavorite = false
    }
   
    
    private func checkIfShouldSave() -> Bool{
        let isThereText = !noteText.isEmpty || !noteTitle.isEmpty
        
        let isThereImages = checkIfAreImagesToSave()
        
        let isThereVoiceNotes = checkIfAreVoicenotesToSave()
        
        let isThereSubtasks = checkIfAreSubtaskToSave()
        
        let isThereDrawing = checkIfIsDrawingToSave()
        
        return (isThereText || isThereImages || isThereDrawing || isThereSubtasks || isThereVoiceNotes)
    }
}

//Image management
extension AddNewNoteViewModel{
    func eraseImage(image: UIImage){
        if let indexToErase = self.imagesToShow.firstIndex(of: image){
            withAnimation {
                let _ = self.imagesToShow.remove(at: indexToErase)
            }
        }
    }
    
    private func checkIfAreImagesToSave() -> Bool{
        if imagesToShow.isEmpty{
            Log.info("No images to save")
            return false
        }
        return true
    }
    
    private func generateImageEntity(image: UIImage) -> NoteImage?{
        
        if let imgData = image.jpegData(compressionQuality: 0.125){
            
            let noteImgEntity = NoteImage(context: DataManager.standard.container.viewContext)
            
            noteImgEntity.id = UUID()
            noteImgEntity.imageData = imgData
            
            return noteImgEntity
        }
        
        return nil
    }
    
    private func getImagesEntities() -> NSSet?{
        
        var tempImageDataSet = Set<NoteImage>()
        
        for img in imagesToShow{
            if let entity = generateImageEntity(image: img){
                tempImageDataSet.insert(entity)
            }
        }
        
        return NSSet(set: tempImageDataSet)
    }
    
    private func linkImagesToNote(note: Note){
        if !checkIfAreImagesToSave() {return}
        
        note.images = getImagesEntities()
    }
}

//Color management
extension AddNewNoteViewModel{
    func getColorView() -> Color{
        let colorEntity = getColorEntity()
        if let colorEntity,
           let colorHex = colorEntity.colorHex,
           let color = Color(hex: colorHex){
            return color
        }
        return Color.clear
    }
    
    private func getColorEntity() -> NoteHighlightColor?{
        
        let predicate = NSPredicate(
            format: "id LIKE %@", selectedColorId
        )
        return DataManager.getFirstData(typeOfEntity: NoteHighlightColor.self, entityName: "NoteHighlightColor", predicate: predicate)
    }
    
    private func linkColorToNote(note: Note){
        note.color = getColorEntity()
    }
    
}

//Tag management
extension AddNewNoteViewModel{
    private func getTagEntity() -> NoteTag?{
        
        guard let tagId = noteTagId else { return nil }
        
        let predicate = NSPredicate(
            format: "id == %@", tagId as CVarArg
        )
        
        return DataManager.getFirstData(typeOfEntity: NoteTag.self, entityName: "NoteTag",predicate: predicate)
    }
    
    private func linkTagToEntity(note: Note){
        note.tag = getTagEntity()
    }
}

//Voicenotes management
extension AddNewNoteViewModel{
    
    private func checkIfAreVoicenotesToSave() -> Bool{
        
        if audioNotes.isEmpty{
            Log.info("No voicenotes to save")
            return false
        }
        
        return true
    }
    
    private func linkVoiceNotesToNoteEntity(noteEntity: Note){
        
        if !checkIfAreVoicenotesToSave() { return }
        
        for voicenote in self.audioNotes{
            voicenote.note = noteEntity
        }
    }
}

//Subtask management
extension AddNewNoteViewModel{
    
    private func checkIfAreSubtaskToSave() -> Bool{
        if self.subtasks.isEmpty{
            Log.info("No subtasks to save")
            return false
        }
        return true
    }
    
    private func generateNoteSubtaskEntity(task: Subtask) -> NoteSubtask{
        let subtaskEntity = NoteSubtask(context: DataManager.standard.container.viewContext)
        
        subtaskEntity.id = UUID()
        subtaskEntity.isDone = task.isChecked
        subtaskEntity.task = task.name
        subtaskEntity.dateCreated = Date()
        
        return subtaskEntity
    }
    
    private func getSubtaskEntities() -> Set<NoteSubtask>{
        
        var tempSubtasksSet = Set<NoteSubtask>()
        
        for task in subtasks{
            
            Log.warning("\(task)")
            
            let subtaskEntity = generateNoteSubtaskEntity(task: task)
            
            tempSubtasksSet.insert(subtaskEntity)
        }
        return tempSubtasksSet
    }
    
    private func linkSubtasksToNote(note: Note){
        
        if !checkIfAreSubtaskToSave() { return }
        
        let subtasks = getSubtaskEntities()
        
        for subtask in subtasks {
            subtask.note = note
        }
    }
}

//Drawing management
extension AddNewNoteViewModel{
    func generateTemporalDrawingEntity(data: Data){
        let drawingEntity = NoteDrawing(context: DataManager.standard.container.viewContext)
        
        drawingEntity.drawingData = data
        drawingEntity.id = UUID()
        
        self.noteDrawingTemp = drawingEntity
        self.drawingDataDisplay = data
    }
    
    func updateDrawingData(data drawingData: Data){
        if let drawing = self.noteDrawingTemp{
            drawing.drawingData = drawingData
            self.drawingDataDisplay = drawingData
        }
    }
    
    func eraseTemporalDrawing(){
        if let noteDrawingTemp{
            DataManager.deleteObject(object: noteDrawingTemp)
            withAnimation(.spring()){
                self.noteDrawingTemp = nil
                self.drawingDataDisplay = nil
            }
        }
    }
    
    private func checkIfIsDrawingToSave() -> Bool{
        
        if noteDrawingTemp == nil{
            Log.info("No Drawing to Save")
            return false
        }
        
        return true
    }
    
    private func linkDrawingToImage(note: Note){
        
        if !checkIfIsDrawingToSave() { return }
        
        if let drawing = noteDrawingTemp{
            note.drawing = drawing
        }
    }
}

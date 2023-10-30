//
//  SubtasksSectionShortNoteViewModel.swift
//  Your Notes
//
//  Created by Franco Marquez on 26/10/23.
//

import Foundation

@MainActor
class SubtasksSectionShortNoteViewModel: ObservableObject{
    
    @Published var noteSubtasks = [NoteSubtask]()
    
    init(noteSet: NSSet?){
        
        guard let subtasksSet = noteSet else{
            Log.error("No set given")
            return
        }
        
        guard var subtasksArray = turnSetToArray(set: subtasksSet) else {
            Log.error("No possible to convert set to subtasks")
            return
        }
        
        subtasksArray = subtasksArray.sorted(by: { subtask1, subtask2 in  subtask1.dateCreated!.compare(subtask2.dateCreated!) == .orderedAscending })
        
        self.noteSubtasks = subtasksArray
    }
    
    func changeStateOfSubtask(subtask: NoteSubtask){
        subtask.isDone.toggle()
        saveData(subtask: subtask)
    }
    
    private func saveData(subtask: NoteSubtask){
        DataManager.standard.saveData(){
            Log.info("State Saved")
            getSubtasks(subtask: subtask)
        }
    }
    
    private func getSubtasks(subtask: NoteSubtask){
        
        guard let noteFromSubtask = subtask.note else {
            Log.error("No note found on subtask")
            return
        }
        
        let predicate = NSPredicate(format: "note == %@"
                    , noteFromSubtask)
        
        self.noteSubtasks = DataManager.getData(typeOfEntity: NoteSubtask.self, entityName: "NoteSubtask", predicate: predicate)    }
    
    private func turnSetToArray(set: NSSet?) -> [NoteSubtask]?{
        
        guard let coreDataSet = set else{
            return nil
        }
        
        guard let subtasksArray = coreDataSet.allObjects as? [NoteSubtask] else {
            Log.error("No possible to convert set of subtasks")
            return nil
        }
        
        return subtasksArray
    }
    
}

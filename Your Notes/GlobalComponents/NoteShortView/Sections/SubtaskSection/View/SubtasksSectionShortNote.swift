//
//  ToDoSection.swift
//  Your Notes
//
//  Created by Franco Marquez on 17/10/23.
//

import SwiftUI

struct SubtasksSectionShortNote: View {
    @StateObject private var viewModel : SubtasksSectionShortNoteViewModel
    
    init(noteSet: NSSet?){
        self._viewModel = StateObject(wrappedValue: SubtasksSectionShortNoteViewModel(noteSet: noteSet))
    }
    
    var body: some View {
        
        VStack{
            
            ForEach(viewModel.noteSubtasks){ subtask in
                Button {
                    viewModel.changeStateOfSubtask(subtask: subtask)
                } label: {
                    HStack{
                        Image(systemName: subtask.isDone ? "checkmark.square" : "square")
                        
                        if let taskText = subtask.task{
                            Text(taskText)
                        }
                        
                        Spacer()
                    }
                    .foregroundStyle(Color(uiColor: .black))
                }
            }
        }
    }
}

//struct ToDoSectionShortNote_Previews: PreviewProvider {
//    static var previews: some View {
//        ToDoSectionShortNote(todoList: .constant(nil))
//    }
//}

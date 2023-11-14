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
            
            ForEach(0..<min(viewModel.noteSubtasks.count, 4), id: \.self){ index in
                Button {
                    viewModel.changeStateOfSubtask(subtask: viewModel.noteSubtasks[index])
                } label: {
                    HStack{
                        Image(systemName: viewModel.noteSubtasks[index].isDone ? GlobalValues.NoFilledIcons.checkmarkSquare : GlobalValues.NoFilledIcons.square)
                        
                        if let taskText = viewModel.noteSubtasks[index].task{
                            Text(taskText)
                        }
                        
                        Spacer()
                    }
                    .foregroundStyle(Color(uiColor: .black))
                }
            }
            
            if viewModel.noteSubtasks.count > 4 {
                Text("\(viewModel.noteSubtasks.count - 4) more ...")
                    .opacity(0.4)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .foregroundColor(ColorManager.subtaskColor)
    }
}

//struct ToDoSectionShortNote_Previews: PreviewProvider {
//    static var previews: some View {
//        ToDoSectionShortNote(todoList: .constant(nil))
//    }
//}

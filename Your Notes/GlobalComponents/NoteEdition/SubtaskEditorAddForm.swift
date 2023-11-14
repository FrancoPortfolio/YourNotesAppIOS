//
//  SubtaskEditorAddForm.swift
//  Your Notes
//
//  Created by Franco Marquez on 13/11/23.
//

import SwiftUI

struct SubtaskEditorAddForm: View {
    
    @Binding var subtasks : [NoteSubtask]?
    @State private var subtaskText = ""
    @State private var showCheckOfSubTaskEditor = false
    
    var body: some View {
        if let subtasks = self.subtasks{
            HStack {
                NoteFormTextField(noteText: self.$subtaskText,
                                  showBackground: false,
                                  placeholderText: "Subtask \(subtasks.count + 1)")
                
                if showCheckOfSubTaskEditor{
                    Button {
                        onButtonPressed()
                    } label: {
                        Image(systemName: GlobalValues.NoFilledIcons.plusSquare)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25, alignment: .center)
                            .padding(.horizontal)
                    }
                }
                
            }
            .onChange(of: self.subtaskText) { newValue in
                if newValue.isEmpty{
                    withAnimation(.linear(duration: 0.2)) {
                        self.showCheckOfSubTaskEditor = false
                    }
                }else{
                    withAnimation(.linear(duration: 0.01)) {
                        self.showCheckOfSubTaskEditor = true
                    }
                }
            }
        }
    }
    
    
    private func onButtonPressed(){
        let subtask = NoteSubtask(context: DataManager.standard.container.viewContext)
        
        subtask.id = UUID()
        subtask.dateCreated = Date()
        subtask.isDone = false
        subtask.task = self.subtaskText
        
        self.subtasks?.append(subtask)
        self.subtaskText = ""
    }
}

//struct SubtaskEditorAddForm: PreviewProvider {
//    static var previews: some View {
//        SubtaskEditorAdd()
//    }
//}

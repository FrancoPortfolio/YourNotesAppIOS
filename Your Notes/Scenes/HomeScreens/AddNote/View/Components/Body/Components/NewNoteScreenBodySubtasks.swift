//
//  NewNoteScreenBodySubtasks.swift
//  Your Notes
//
//  Created by Franco Marquez on 14/11/23.
//

import SwiftUI

struct NewNoteScreenBodySubtasks: View {
    
    @StateObject var viewModel: AddNewNoteViewModel
    @State private var showCheckOfSubTaskEditor = false
    
    var body: some View {
        VStack{
            Text("Subtasks")
                .newNoteSubtitle()
            
            VStack(spacing: 10){
                
                if !viewModel.subtasks.isEmpty{
                    VStack (spacing: 10) {
                        ForEach(viewModel.subtasks){ subtask in
                            SubtaskNoteEditor(subtask: subtask)
                        }
                    }
                    .padding(.top)
                }
                
                HStack {
                    NoteFormTextField(noteText: $viewModel.tempSubtaskText,
                                      showBackground: false,
                                      placeholderText: "Subtask \(viewModel.subtasks.count + 1)")
                    
                    if showCheckOfSubTaskEditor{
                        Button {
                            viewModel.subtasks.append(
                                Subtask(name: viewModel.tempSubtaskText,
                                        isChecked: false)
                            )
                            viewModel.tempSubtaskText = ""
                            
                        } label: {
                            Image(systemName: GlobalValues.NoFilledIcons.plusSquare)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25, alignment: .center)
                                .padding(.horizontal)
                        }
                    }
                    
                }
                .onChange(of: viewModel.tempSubtaskText) { newValue in
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
                .padding(.top,10)
            }
        }
    }
}

//struct NewNoteScreenBodySubtasks_Previews: PreviewProvider {
//    static var previews: some View {
//        NewNoteScreenBodySubtasks()
//    }
//}

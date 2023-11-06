//
//  NewNoteScreen.swift
//  Your Notes
//
//  Created by Franco Marquez on 17/10/23.
//

import SwiftUI
import AVFoundation
import PencilKit

struct NewNoteScreen: View {
    
    @Environment (\.presentationMode) var presentationMode
    @StateObject private var viewModel: AddNewNoteViewModel = AddNewNoteViewModel()
    @StateObject private var audioManager = AudioRecordingPlayingManager()
    @State private var showCheckOfSubTaskEditor = false
    @State private var tempImageCamera : UIImage = UIImage()
    
    //temp
    
    @State private var mediaTypeToAdd : AddNoteDestinations? = nil
    @State private var presentMediaAdditionSheet : Bool = false
    
    
    var body: some View {
        
        ScrollView{
            //Top part
            TopSectionNewNoteScreen(viewModel: self.viewModel,
                                    audioManager: self.audioManager)
            
            //Subtasks part
            SubtasksPart
            
            //Class selection part
            NewNoteTagSectionView(actualTag: $viewModel.noteTagId)
            
            //Color selection part
            NewNoteColorSectionView(selectedColorId: $viewModel.selectedColorId)
        }
        .onAppear{
            self.mediaTypeToAdd = .image
        }
        .scrollIndicators(.hidden)
        .padding()
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background {
            ColorManager.backgroundColor
                .ignoresSafeArea()
        }
        //Navigation Config
        .navigationTitle("New Note")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(ColorManager.backgroundColor, for: .navigationBar)
        .alert("No data to save", isPresented: $viewModel.presentNoDataAlert, actions: {
            Button("Ok", role: .cancel, action: {})
        }, message: {})
        //Toolbar items
        .toolbar(content: {
            ToolbarItem {
                addNoteButton
            }
        })
    }
}
//Subtasks Part
extension NewNoteScreen{
    private var SubtasksPart: some View{
        Group{
            
            Text("Subtasks")
                .newNoteSubtitle()
                .padding(.bottom,5)
            
            VStack{
                
                VStack (spacing: 10) {
                    ForEach(viewModel.subtasks){ subtask in
                        SubtaskNoteEditor(subtask: subtask)
                    }
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

//ToolbarItems
extension NewNoteScreen{
    private var addNoteButton: some View{
        Button("Add Note") {
            //Add note
            Log.info("Adding note to db")
            viewModel.saveNote(){
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

//Functions
extension NewNoteScreen{
}

//struct NewNoteScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        NewNoteScreen()
//    }
//}

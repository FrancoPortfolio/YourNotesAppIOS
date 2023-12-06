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
    
    var body: some View {
        
        ScrollView{
            //Body
            NewNoteScreenBody(viewModel: self.viewModel)
            
            //Class selection part
            NewNoteTagSectionView(actualTag: $viewModel.noteTagId)
            
            //Color selection part
            NewNoteColorSectionView(selectedColorId: $viewModel.selectedColorId)
        }
        
        .scrollIndicators(.hidden)
        .padding()
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background {
            ColorManager.backgroundColor
                .ignoresSafeArea()
        }
        .overlay {
            if viewModel.isSaving{
                Color.black
            }
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

//ToolbarItems
extension NewNoteScreen{
    private var addNoteButton: some View{
        Button("Add Note") {
            //Add note
            Log.info("Adding note to db")
            viewModel.save(){
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

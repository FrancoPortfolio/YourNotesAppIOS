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
    @State private var presentAddMediaGallery : Bool = false
    @State private var presentAddMediaCamera : Bool = false
    @State private var presentAddMediaVoice : Bool = false
    @State private var presentAddMediaDrawing : Bool = false
    @State private var mediaTypeToAdd : AddNoteDestinations = .image
    @State private var tempImageCamera : UIImage = UIImage()
    
    
    var body: some View {
        
        ScrollView{
            //Top part
            TopPart
            
            //Subtasks part
            SubtasksPart
            
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
        //Navigation Config
        .navigationTitle("New Note")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(ColorManager.backgroundColor, for: .navigationBar)
        //Sheets
        .sheet(isPresented: $presentAddMediaGallery){ galleryScreen }
        .sheet(isPresented: $presentAddMediaCamera){ cameraScreen }
        .sheet(isPresented: $presentAddMediaVoice){ voiceRecordingScreen }
        .sheet(isPresented: $presentAddMediaDrawing, content: { drawingScreen })
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

//Top Part
extension NewNoteScreen{
    
    private var TopPart: some View{
        Group{
            VStack (spacing: 20){
                NoteFormTextField(noteText: $viewModel.noteText)
                
                if !viewModel.imagesToShow.isEmpty{
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0..<viewModel.imagesToShow.count, id: \.self){ imageIndex in
                                Image(uiImage: viewModel.imagesToShow[imageIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay {
                                        Button {
                                            viewModel.imagesToShow.remove(at: imageIndex)
                                        } label: {
                                            VStack{
                                                HStack{
                                                    Spacer()
                                                    Image(systemName: GlobalValues.NoFilledIcons.xButton)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .foregroundStyle(Color.white)
                                                        .fontWeight(.thin)
                                                        .frame(width: 25, height:25)
                                                        .padding(5)
                                                }.frame(maxWidth: .infinity)
                                                Spacer()
                                            }
                                            .frame(maxHeight: .infinity)
                                        }
                                        
                                    }
                            }
                        }
                    }
                }
                
                if !viewModel.audioFilesUrlStrings.isEmpty{
                    VStack{
                        ForEach(audioManager.assets){ recording in
                            VoiceRecordingPreview(audioManager: audioManager,
                                                  recording: recording)
                        }
//                        ForEach(viewModel.audioFilesUrlStrings, id: \.self){ audioPathString in
//                            VoiceRecordingPreview(audioManager: audioManager,
//                                                  audioPathString: audioPathString)
//                        }
                    }
                }
                
                if let data = viewModel.drawingData {
                    VStack{
                        Image(uiImage: UIImage.getUIImageFromCanvasData(data: data))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .background{
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                    }
                }
                
                HStack{
                    NoteAddSectionButton (iconName: GlobalValues.FilledIcons.imageIcon){
                        presentAddMediaGallery.toggle()
                    }
                    Spacer()
                    NoteAddSectionButton (iconName: GlobalValues.FilledIcons.cameraIcon){
                        presentAddMediaCamera.toggle()
                    }
                    Spacer()
                    NoteAddSectionButton (iconName: GlobalValues.FilledIcons.micIcon){
                        presentAddMediaVoice.toggle()
                    }
                    Spacer()
                    NoteAddSectionButton (iconName: GlobalValues.FilledIcons.brushIcon){
                        presentAddMediaDrawing.toggle()
                    }
                }
            }
        }
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

//Sheets
extension NewNoteScreen{
    
    private var galleryScreen: some View{
        GalleryPicker(images: $viewModel.imagesToShow)
            .ignoresSafeArea()
    }
    
    private var cameraScreen: some View{
        CameraScreen(selectedImage: $tempImageCamera)
            .ignoresSafeArea()
            .onDisappear {
                viewModel.imagesToShow.append(self.tempImageCamera)
                tempImageCamera = UIImage()
            }
    }
    
    private var voiceRecordingScreen: some View{
        VoiceRecordingView(noteId: viewModel.noteId,
                           recordingsNames: $viewModel.audioFilesUrlStrings) { fileName in
            
            self.viewModel.audioFilesUrlStrings.append(fileName)
            let fileHandler = FileManagerHandler()
            let baseDocumentsURL = fileHandler.findDocumentDirectory()
            let urlToSaveOnAssets = baseDocumentsURL.appendingPathComponent(GlobalValues.Strings.baseFolderVoicenotes)
                .appendingPathComponent(self.viewModel.noteId)
                .appendingPathComponent(fileName)
            
            let recording = TemporalRecording(fileName: fileName,
                              completeTemporalUrl: urlToSaveOnAssets.absoluteString,
                              asset: AVAsset(url: urlToSaveOnAssets))
            
            self.audioManager.assets.append(recording)
            self.presentAddMediaVoice = false
            Log.info("Actual audio paths: \(self.viewModel.audioFilesUrlStrings)")
            
        }
        .ignoresSafeArea()
    }
    
    private var drawingScreen: some View{
        DrawingViewForm(){ drawingData in
            self.viewModel.drawingData = drawingData
        }
            .ignoresSafeArea()
        
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

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
                                                    Image(systemName: "x.circle")
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
                        ForEach(viewModel.audioFilesUrlStrings, id: \.self){ audioPathString in
                            VoiceRecordingPreview(audioManager: audioManager,
                                                  audioPathString: audioPathString)
                        }
                    }
                }
                
                if let data = viewModel.drawingData {
                    VStack{
                        Image(uiImage: self.getUIImageFromCanvasData(data: data, size: CGSize(width: 300, height: 450)))
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
                    NoteAddSectionButton (iconName: "photo.fill"){
                        presentAddMediaGallery.toggle()
                    }
                    Spacer()
                    NoteAddSectionButton (iconName: "camera.fill"){
                        presentAddMediaCamera.toggle()
                    }
                    Spacer()
                    NoteAddSectionButton (iconName: "mic.fill"){
                        presentAddMediaVoice.toggle()
                    }
                    Spacer()
                    NoteAddSectionButton (iconName: "paintbrush.pointed.fill"){
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
                            Image(systemName: "plus.square")
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
            Log.info("Add note to db")
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
                           recordingsNames: $viewModel.audioFilesUrlStrings) { urlString in
            
            self.viewModel.audioFilesUrlStrings.append(urlString)
            self.audioManager.assets.append(
                Recording(dataUrl: urlString,
                          asset: AVAsset(url: URL(string: urlString)!)))
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
    
    private func getUIImageFromCanvasData(data: Data, size: CGSize) -> UIImage{
        let canvas = PKCanvasView()
        var image = UIImage()
        let cgRect = CGRect(origin: CGPoint.zero,size: size)
        do{
            try canvas.drawing = PKDrawing(data: data)
            image = canvas.drawing.image(from: cgRect, scale: 10.0)
        } catch {
            Log.error("Error making image from canvas: \(error)")
        }
        return image
    }
    
}

struct NewNoteScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewNoteScreen()
    }
}

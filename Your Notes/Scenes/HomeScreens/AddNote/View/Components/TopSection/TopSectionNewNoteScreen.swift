//
//  TopSectionNewNoteScreen.swift
//  Your Notes
//
//  Created by Franco Marquez on 31/10/23.
//

import SwiftUI
import AVFoundation

struct TopSectionNewNoteScreen: View {
    
    @Environment (\.presentationMode) var presentationMode
    @StateObject var viewModel: AddNewNoteViewModel
    @StateObject var audioManager: AudioRecordingPlayingManager
    @State private var presentGalleryMedia = false
    @State private var presentCameraMedia = false
    @State private var presentMicMedia = false
    @State private var presentDrawingMedia = false
    
    var body: some View {
        VStack(spacing: 20){
            
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
            
            TopSectionNewNoteScreenEditButtons(presentGalleryMedia: $presentGalleryMedia,
                                               presentCameraMedia: $presentCameraMedia,
                                               presentMicMedia: $presentMicMedia,
                                               presentDrawingMedia: $presentDrawingMedia)
        }
        .sheet(isPresented: self.$presentGalleryMedia, content: {
            galleryScreen
        })
        .sheet(isPresented: self.$presentCameraMedia, content: {
            cameraScreen
        })
        .sheet(isPresented: self.$presentMicMedia, content: {
            voiceRecordingScreen
        })
        .sheet(isPresented: self.$presentDrawingMedia, content: {
            drawingScreen
        })
    }
}

//Sheets
extension TopSectionNewNoteScreen{
    
    private var galleryScreen: some View{
        GalleryPicker(images: $viewModel.imagesToShow)
            .ignoresSafeArea()
    }
    
    private var cameraScreen: some View{
        CameraScreen(selectedImage: $viewModel.tempImageCamera)
            .ignoresSafeArea()
            .onDisappear {
                if let image = viewModel.tempImageCamera{
                    viewModel.imagesToShow.append(image)
                    viewModel.tempImageCamera = nil
                }
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
            self.presentMicMedia.toggle()
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


//struct TopSectionNewNoteScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        TopSectionNewNoteScreen()
//    }
//}

//
//  NewNoteScreen.swift
//  Your Notes
//
//  Created by Franco Marquez on 17/10/23.
//

import SwiftUI

struct NewNoteScreen: View {
    
    // MARK: - ERASE THIS AND CHANGE FOR BASIC COLORS ON DB
    private var defaultColors = ["#FFFFFF","#FF0000","#00FF00","#008000","#0000FF","#800080"]
    
    @StateObject private var viewModel: AddNewNoteViewModel = AddNewNoteViewModel()
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
            ClassSelectionPart
            
            //Color selection part
            Group{
                Text("Select color")
                    .newNoteSubtitle()
                
                NoteColorSelector(colorList: defaultColors,
                                  selectedColor: $viewModel.selectedColorHex)
            }
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
        .sheet(isPresented: $presentAddMediaVoice, content: {
            Text("Voice")
        })
        .sheet(isPresented: $presentAddMediaDrawing, content: {
            Text("Drawing")
        })
        
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

//Class Selection Part
extension NewNoteScreen{
    private var ClassSelectionPart: some View{
        Group{
            Text("Select tag")
                .newNoteSubtitle()
            
            NoteTagSelector(actualTag: $viewModel.noteClass,
                            tagList: $viewModel.tagClasses)
        }
    }
}

//Color Selection Part
extension NewNoteScreen{
    private var ColorSelectionPart: some View{
        Group{
            Text("Select color")
                .newNoteSubtitle()
            
            NoteColorSelector(colorList: defaultColors,
                              selectedColor: $viewModel.selectedColorHex)
        }
    }
}

//ToolbarItems
extension NewNoteScreen{
    private var addNoteButton: some View{
        Button("Add Note") {
            //Add note
            print("Add note to db")
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
    
}


fileprivate extension Text{
    func newNoteSubtitle() -> some View{
        self
            .font(.headline)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top)
        
    }
}

#Preview {
    NavigationStack{
        NewNoteScreen()
    }
}

#Preview {
    NavigationStack{
        NewNoteScreen()
    }
    .preferredColorScheme(.dark)
}

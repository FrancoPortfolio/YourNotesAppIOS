//
//  ExtendedNoteScreen.swift
//  Your Notes
//
//  Created by Franco Marquez on 6/11/23.
//

import SwiftUI

struct ExtendedNoteScreen: View {
    
    @StateObject private var viewModel: ExtendedNoteViewModel
    
    init(noteId: String) {
        self._viewModel = StateObject(wrappedValue: ExtendedNoteViewModel(noteId: noteId))
    }
    
    var body: some View {
        
        ZStack{
            
            ColorManager.backgroundColor.ignoresSafeArea()
            
            ScrollView(.vertical){
                LazyVStack(spacing: 15){
                
                    //Text
                    Text(viewModel.bodyText)
                    
                    //Images
                    ScrollView(.horizontal){
                        LazyHStack{
                            ForEach(viewModel.images, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 400)
                                    .clipped()
                            }
                        }
                    }
                    
                    //Voicenotes
                    if !viewModel.recordings.isEmpty{
                        RecordingPlayerView(voicenotes: viewModel.recordings)
                    }
                    //Drawing
                    if let image = viewModel.drawingImage{
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .background {
                                Color.white
                            }
                            .frame(width: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    //Subtasks
                    VStack{
                        if let subtasks = viewModel.subtasks{
                            VStack (spacing: 6){
                                ForEach(subtasks){ subtask in
                                    Button {
                                        viewModel.changeStateSubtask(subtask: subtask)
                                    } label: {
                                        HStack{
                                            Image(systemName: subtask.isDone ? GlobalValues.NoFilledIcons.checkmarkSquare : GlobalValues.NoFilledIcons.square)
                                                .padding(.trailing)
                                            
                                            if let taskText = subtask.task{
                                                Text(taskText)
                                            }
                                            
                                            Spacer()
                                        }
                                        .font(.system(size: 24))
                                        .foregroundColor(.black)
                                    }

                                }
                            }
                        }
                    }
                    
                }
            }
            .padding(.horizontal)
            .scrollIndicators(.hidden)
        }
        .navigationBarTitle(viewModel.title)
        .toolbarBackground(ColorManager.backgroundColor, for: .navigationBar)
//        .navigationBarTitleDisplayMode(.inline)
        
    }
}

//struct ExtendedNoteScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        ExtendedNoteScreen()
//    }
//}

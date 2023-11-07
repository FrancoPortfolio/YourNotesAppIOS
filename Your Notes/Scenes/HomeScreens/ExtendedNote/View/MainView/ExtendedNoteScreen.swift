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
                    
                    //Drawing
                    
                    
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
//        .navigationBarTitleDisplayMode(.inline)
        
    }
}

//struct ExtendedNoteScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        ExtendedNoteScreen()
//    }
//}

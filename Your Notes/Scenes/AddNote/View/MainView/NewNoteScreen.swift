//
//  NewNoteScreen.swift
//  Your Notes
//
//  Created by Franco Marquez on 17/10/23.
//

import SwiftUI

struct NewNoteScreen: View {
    
    @State private var noteText : String = ""
    
    var body: some View {
        
        VStack{
            //Top part
            Group {
                VStack (spacing: 20){
                    NoteTextField(noteText: $noteText)
                    
                    HStack{
                        NoteAddSectionButton (iconName: "photo.fill") {}
                        Spacer()
                        NoteAddSectionButton (iconName: "camera.fill") {}
                        Spacer()
                        NoteAddSectionButton (iconName: "mic.fill") {}
                        Spacer()
                        NoteAddSectionButton (iconName: "paintbrush.pointed.fill") {}
                    }
                }
                
            }
            
            Spacer()
            
        }
        .padding()
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background {
            ColorManager.backgroundColor
                .ignoresSafeArea()
        }
        
    }
    
    
}

#Preview {
    NewNoteScreen()
}

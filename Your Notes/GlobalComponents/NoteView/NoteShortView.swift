//
//  NoteView.swift
//  Your Notes
//
//  Created by Franco Marquez on 16/10/23.
//

import SwiftUI

struct NoteShortView: View {
    
    @State var note: Note = Note.NoteMockup5
    
    private var numberOfSections: Int{
        if note.contentTypes.count >= 1 {
            return 2
        }
        return note.contentTypes.count
    }
    
    var body: some View {
        VStack{
            
            //Pin Icon
            if note.isPinned{
                HStack{
                    Image(systemName: "pin.fill")
                        .font(.footnote)
                        .rotationEffect(Angle(degrees: 45))
                        .foregroundColor(Color.gray.opacity(0.9))
                        .padding([.leading,.top],5)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            //Top Left Indicators
            HStack{
                if note.isFavorite {
                    Image(systemName: "star")
                        .font(.callout)
                        .padding(.top, note.isPinned ? 0 : 10)
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal,10)
            
            //Sections to show on note, max of 2 following array order
            VStack(spacing: 10) {
                
                ForEach(0..<numberOfSections, id: \.self) { contentOrder in
                    switch note.contentTypes[contentOrder]{
                    case .PlainText:
                        TextSectionShortNote(textData: note.noteData.textData)
                            .frame(maxWidth: .infinity)
                        
                    case .ToDo:
                        ToDoSectionShortNote(todoList: $note.noteData.toDoData)
                            .frame(maxWidth: .infinity)
                        
                    case .Image:
                        Text("Image")//ImageSection()
                            .frame(height: 80)
                            .frame(maxWidth: .infinity)
                        
                    case .Voice:
                        if let data = note.noteData.voiceData {
                            VoiceNoteSectionShortNote(voiceNoteUrl: data[0],
                                                      noteId: note.id)
                                .frame(maxWidth: .infinity)
                        }
                    case .Drawing:
                        if contentOrder != 1 {
                            Text("Drawing")//DrawingSection()
                                .frame(height: 80)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                
            }.padding(.horizontal,10)
                .padding(.top,5)
                .padding(.bottom)
            
        }
        .background{
            Color.init(hex: note.highlightColor)
        }
        .cornerRadius(20, corners: note.isPinned ? [.bottomLeft,.bottomRight,.topLeft] : .allCorners)
        
    }
}

#Preview {
    NoteShortView(note: Note.NoteMockup5)
        .frame(maxWidth: 200, maxHeight: 250)
}

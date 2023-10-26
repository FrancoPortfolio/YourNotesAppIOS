//
//  NoteView.swift
//  Your Notes
//
//  Created by Franco Marquez on 16/10/23.
//

import SwiftUI

struct NoteShortView: View {
    
    var note : Note
    
    private var isPinned : Bool {
        return true//note.isPinned
    }
    
    private var isFavorite: Bool{
        return true//note.isFavorite
    }
    
    private var contentSections: ([contentSections], Int){
        
        var sections : [contentSections] = []
        
        if note.text != nil && !(note.text?.isEmpty ?? true){
            sections.append(.text)
        }
        
        if let images = note.images{
            if images.count != 0{
                sections.append(.images)
            }
        }
        
        if let subtasks = note.subtasks{
            if subtasks.count != 0{
                sections.append(.subtasks)
            }
        }
        
        if let voicenotes = note.voicenotes{
            if voicenotes.count != 0{
                sections.append(.voicenotes)
            }
        }
        
        if note.drawing != nil{
            sections.append(.drawing)
        }
    
        return (sections, min(2, sections.count))
    }
    
    
    var body: some View {
        VStack{
            
            //Pin Icon
            if isPinned{
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
                if isFavorite {
                    Image(systemName: "star")
                        .font(.callout)
                        .padding(.top, note.isPinned ? 0 : 0)
                }

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal,10)
            
            //Sections to show on note, max of 2 following array order
            VStack(spacing: 10) {
                
                ForEach(0..<contentSections.1, id: \.self) { contentOrder in
                    
                    let section = contentSections.0[contentOrder]
                    
                    switch section{
                        
                    case .text:
                        TextSectionShortNote(textData: note.text)
                    
                    case .subtasks:
                        Text("Subtasks")
                        
                    case .images:
                        Text("Images")
                        
                    case .voicenotes:
                        Text("Boicenotes")
                        
                    case .drawing:
                        Text("Drawing")
                    }
                }
                
            }.padding(.horizontal,10)
                .padding(.top,5)
                .padding(.bottom)
            
        }
        .background{
            
            if let colorHex = note.color?.colorHex{
                Color.init(hex: colorHex).frame(maxWidth: .infinity, maxHeight: .infinity)
            }
           
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(20, corners: isPinned ? [.bottomLeft,.bottomRight,.topLeft] : .allCorners)
        
    }
}

fileprivate enum contentSections: CaseIterable, Hashable{
    case text,images,voicenotes,drawing,subtasks
}

fileprivate struct NoteShortViewPreviewWrapper: View{
    
    @FetchRequest(sortDescriptors: []) var note: FetchedResults<Note>
    
    var body: some View{
        NoteShortView(note: note.first!)
            .frame(maxWidth: 200, maxHeight: 250)
    }
    
}

//struct NoteShortView_Previews: PreviewProvider {
//    static var previews: some View {
//        NoteShortViewPreviewWrapper()
//    }
//}

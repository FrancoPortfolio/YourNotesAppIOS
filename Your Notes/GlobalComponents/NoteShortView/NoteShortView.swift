//
//  NoteView.swift
//  Your Notes
//
//  Created by Franco Marquez on 16/10/23.
//

import SwiftUI

struct NoteShortView: View {
    
    @State private var showItself = true
    
    var note : Note
    
    private var isPinned : Bool {
        return note.isPinned
    }
    
    private var isFavorite: Bool{
        return note.isFavorite
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
            if showItself{
                VStack{
                    //Pin Icon
                    if isPinned{
                        HStack{
                            Image(systemName: "pin.fill")
                                .font(.footnote)
                                .rotationEffect(Angle(degrees: 45))
                                .foregroundColor(Color.gray.opacity(0.9))
                                .padding([.leading,.top,.trailing],5)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    //Top Left Indicators
                    HStack{
                        //Favorite indicator
                        if isFavorite {
                            Image(systemName: "star.fill")
                                .font(.callout)
                        }
                        //Other indicators
                        if contentSections.0.count > 2{
                            ForEach(2..<Int(contentSections.0.count)){ index in
                                
                                switch contentSections.0[index]{
                                case .images:
                                    Image(systemName: "star.fill")
                                        .font(.callout)
                                case .subtasks:
                                    Image(systemName: "star.fill")
                                        .font(.callout)
                                case .text:
                                    Image(systemName: "star.fill")
                                        .font(.callout)
                                case .voicenotes:
                                    Image(systemName: "star.fill")
                                        .font(.callout)
                                case .drawing:
                                    Image(systemName: "star.fill")
                                        .font(.callout)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal,10)
                    .padding(.top, note.isPinned ? 0 : 10)
                    //Sections to show on note, max of 2 following array order
                    VStack(spacing: 0) {
                        
                        ForEach(0..<contentSections.1, id: \.self) { contentOrder in
                            
                            let section = contentSections.0[contentOrder]
                            
                            switch section{
                                
                            case .text:
                                TextSectionShortNote(textData: note.text)
                                    .padding(.horizontal,10)
                                    .padding(.bottom,10)
                                
                            case .subtasks:
                                SubtasksSectionShortNote(noteSet: note.subtasks)
                                    .padding(.horizontal,10)
                                    .padding(.leading,5)
                                    .padding(.bottom,10)
                                
                            case .images:
                                ImagesSectionShortNote(imagesSet: note.images)
                                    .padding(.top,(isPinned || isFavorite) ? 0 : 7.5)
                                
                            case .voicenotes:
                                VoiceNoteSectionShortNote(voicenoteSet: note.voicenotes)
                                    .padding(.vertical)
                                
                            case .drawing:
                                Text("Drawing")
                            }
                        }
                        
                    }
                    .padding(.top,5)
                }
            }
        }
        .background{
            
            if let colorHex = note.color?.colorHex{
                Color.init(hex: colorHex).frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(20, corners: isPinned ? [.bottomLeft,.bottomRight,.topLeft] : .allCorners)
        .onAppear{
            showItself = true
        }
        .onDisappear{
            showItself = false
        }
        
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

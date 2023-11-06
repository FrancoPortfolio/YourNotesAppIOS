//
//  NoteView.swift
//  Your Notes
//
//  Created by Franco Marquez on 16/10/23.
//

import SwiftUI

struct NoteShortView<Content: View>: View {
    
    @State private var showItself = true
    @State private var showPopover = false
    @StateObject var audioManager: AudioRecordingPlayingManager
    
    var note : Note
    var popoverView: () -> Content
    
    private var isPinned : Bool {
        return note.isPinned
    }
    
    private var isFavorite: Bool{
        return note.isFavorite
    }
    
    private var isTagged: Bool{
        if note.tag?.tag != nil {
            return true
        }
        return false
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
                VStack(spacing: 0){
                    //Pin Icon
                    HStack{
                        
                        if isTagged{
                            HStack{
                                Text("#\(note.tag!.tag!)")
                                    .font(.footnote)
                                    .foregroundColor(ColorManager.textColor)
                                    .opacity(0.8)
                                    .padding(.leading, 10)
                                if !isPinned{
                                    Spacer()
                                }
                            }
                        }
                        
                        if isPinned && isTagged{
                            Spacer()
                        }
                        
                        if isPinned{
                            HStack{
                                if !isTagged{
                                    Spacer()
                                }
                                Image(systemName: GlobalValues.FilledIcons.pinIcon)
                                    .font(.footnote)
                                    .rotationEffect(Angle(degrees: 45))
                                    .foregroundColor(Color.gray.opacity(0.9))
                                    .frame(width: 20, alignment: .trailing)
                                    .padding([.trailing],5)
                            }
                            
                        }
                    }
                    .padding(.top, isPinned || isTagged ? 7 : 0)
                    //Top Left Indicators
                    HStack{
                        //Favorite indicator
                        if isFavorite {
                            Image(systemName: GlobalValues.FilledIcons.favoriteStar)
                                .font(.callout)
                        }
                        //Other indicators
                        if contentSections.0.count > 2{
                            HStack{
                                ForEach(2..<Int(contentSections.0.count)){ index in
                                    
                                    switch contentSections.0[index]{
                                    case .images: Image(systemName: GlobalValues.FilledIcons.imageIcon)
                                    case .subtasks: Image(systemName: GlobalValues.FilledIcons.subtaskIcon)
                                    case .text: Image(systemName: GlobalValues.FilledIcons.textIcon)
                                    case .voicenotes: Image(systemName: GlobalValues.FilledIcons.micIcon)
                                    case .drawing: Image(systemName: GlobalValues.FilledIcons.brushIcon)
                                    }
                                }
                            }
                            .font(.callout)
                            .foregroundColor(ColorManager.textColor)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal,10)
                    .padding(.vertical, isPinned || isTagged ? 0 : 7)
                    //Sections to show on note, max of 2 following array order
                    VStack(spacing: 0) {
                        
                        ForEach(0..<contentSections.1, id: \.self) { contentOrder in
                            
                            let section = contentSections.0[contentOrder]
                            
                            switch section{
                                
                            case .text:
                                TextSectionShortNote(textData: note.text)
                                    .padding(.horizontal,10)
                                    .padding(.vertical,5)
                                
                            case .subtasks:
                                SubtasksSectionShortNote(noteSet: note.subtasks)
                                    .padding(.horizontal,10)
                                    .padding(.leading,5)
                                    .padding(.vertical,10)
                                
                            case .images:
                                ImagesSectionShortNote(imagesSet: note.images)
                                    .padding(.top,(isPinned || isFavorite) ? 0 : 7.5)
                                
                            case .voicenotes:
                                VoiceNoteSectionShortNote(voicenoteSet: note.voicenotes, noteId: note.id!.uuidString,
                                                          audioManager: audioManager)
                                .padding(.vertical)
                                
                            case .drawing:
                                DrawingSectionShortNoteView(noteDrawing: note.drawing)
                            }
                        }
                    }
                }
            }
        }
        .background{
            
            if let colorHex = note.color?.colorHex{
                Color.init(hex: colorHex).frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(10, corners: isPinned ? [.bottomLeft,.bottomRight,.topLeft] : .allCorners)
        .popover(isPresented: self.$showPopover, content: {
            popoverView()
        })
//        .modifier(TapAndLongPressModifier(tapAction: {
//            Log.info("Do on tap")
//        }, longPressAction: {
//            self.showPopover.toggle()
//        }))
        .onAppear{
            showItself = true
        }
        .onDisappear{
            showItself = false
        }
        .shadow(radius: 3)
        
    }
}

fileprivate enum contentSections: CaseIterable, Hashable{
    case text,images,voicenotes,drawing,subtasks
}

//fileprivate struct NoteShortViewPreviewWrapper: View{
//    
//    @FetchRequest(sortDescriptors: []) var note: FetchedResults<Note>
//    
//    var body: some View{
//        NoteShortView(note: note.first!)
//            .frame(maxWidth: 200, maxHeight: 250)
//    }
//    
//}

//struct NoteShortView_Previews: PreviewProvider {
//    static var previews: some View {
//        NoteShortViewPreviewWrapper()
//    }
//}

//
//  NoteShortBody.swift
//  Your Notes
//
//  Created by Franco Marquez on 6/11/23.
//

import SwiftUI

struct NoteShortBody: View {
    
    
    var note: Note
    @StateObject var audioManager: AudioRecordingPlayingManager
    var isPinned : Bool
    var isFavorite : Bool
    var contentSections : ([contentSections],Int)
    
    var title : String{
        
        if let title = note.title{
            if title.isEmpty || title == ""{
                return ""
            }
            return title
        }
        
        return ""
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            if title != ""{
                Text(title)
                    .bold()
                    .foregroundColor(ColorManager.textTitleColor)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
            }
            
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

enum contentSections: CaseIterable, Hashable{
    case text,images,voicenotes,drawing,subtasks
}


//struct NoteShortBody_Previews: PreviewProvider {
//    static var previews: some View {
//        NoteShortBody()
//    }
//}

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
    
    var title : String{
        
        if let title = note.title{
            if !(title.isEmpty || title == ""){
                return title
            }
        }
        
        return "(No title note)"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            Text(title)
                .bold()
                .foregroundColor(ColorManager.textTitleColor)
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .padding(.vertical,10)
            
            if let noteTextBody = note.text, !noteTextBody.isEmpty{
                Text(noteTextBody)
                    .foregroundColor(ColorManager.textColor)
                    .lineLimit(3)
                    .font(.body)
                    .padding(.horizontal, 10)
                    .padding(.bottom,10)
                    
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

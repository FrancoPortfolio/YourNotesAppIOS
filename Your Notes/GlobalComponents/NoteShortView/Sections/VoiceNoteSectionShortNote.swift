//
//  VoiceNoteSectionShortNote.swift
//  Your Notes
//
//  Created by Franco Marquez on 17/10/23.
//

import SwiftUI

struct VoiceNoteSectionShortNote: View {
    
    @StateObject private var audioManager = AudioRecordingPlayingManager()
    
    var voiceNoteUrl: String?
    var noteId: String
    
    var body: some View {
        VStack{
            
            Button {
                
                if audioManager.isPlaying {
                    audioManager.stopPlaying()
                }else{
                    audioManager.startPlaying(fileName: voiceNoteUrl)
                }
                
            } label: {
                Image(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30, alignment: .center)
                    .padding(10)
                    .font(.title)
                    .foregroundStyle(Color.black)
                
            }
        }
    }
}

//struct VoiceNoteSectionShortNote_Previews: PreviewProvider {
//    static var previews: some View {
//        VoiceNoteSectionShortNote(noteId: "xd")
//            .frame(width: 200, height: 80)
//            .getFrameBorderPainted()
//    }
//}

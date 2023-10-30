//
//  VoiceNoteSectionShortNote.swift
//  Your Notes
//
//  Created by Franco Marquez on 17/10/23.
//

import SwiftUI

struct VoiceNoteSectionShortNote: View {
    
    @StateObject private var viewModel : VoiceNoteSectionShortNoteViewModel
    
    init(voicenoteSet: NSSet?) {
        self._viewModel = StateObject(wrappedValue: VoiceNoteSectionShortNoteViewModel(voicenoteSet: voicenoteSet))
    }
    
    var body: some View {
        VStack{
            
            Button {
                
                if viewModel.audioPlayer.isPlaying {
                    viewModel.pausePlaying()
                }else{
                    viewModel.startPlaying()
                }
                
            } label: {
                Image(systemName: viewModel.audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
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

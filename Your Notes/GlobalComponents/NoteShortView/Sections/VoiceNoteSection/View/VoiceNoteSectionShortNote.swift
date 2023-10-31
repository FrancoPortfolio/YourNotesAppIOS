//
//  VoiceNoteSectionShortNote.swift
//  Your Notes
//
//  Created by Franco Marquez on 17/10/23.
//

import SwiftUI

struct VoiceNoteSectionShortNote: View {
    
    @StateObject private var viewModel : VoiceNoteSectionShortNoteViewModel
    @StateObject var audioManager : AudioRecordingPlayingManager
    
    init(voicenoteSet: NSSet?, noteId: String, audioManager: AudioRecordingPlayingManager) {
        self._viewModel = StateObject(wrappedValue: VoiceNoteSectionShortNoteViewModel(voicenoteSet: voicenoteSet, noteId: noteId))
        self._audioManager = StateObject(wrappedValue: audioManager)
    }
    
    private var isThisPlaying: Bool{
        if audioManager.isPlaying{
            return audioManager.actualFilePlayingURLString == viewModel.audioUrl
        }
        return false
    }
    
    private var iconName: String{
        if isThisPlaying{
            if audioManager.isPaused{
                return GlobalValues.FilledIcons.Media.play
            } else {
                return GlobalValues.FilledIcons.Media.pause
                
            }
        }
        return GlobalValues.FilledIcons.Media.play
    }
    
    var body: some View {
        VStack{
            Button {
                doWhenButtonPressed()
            } label: {
                Image(systemName: iconName)
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

extension VoiceNoteSectionShortNote{
    private func doWhenButtonPressed(){
        
        if !audioManager.isPlaying{
            audioManager.startPlaying(filePath: viewModel.audioUrl)
            return
        }
        
        if audioManager.isPaused{
            audioManager.resumePlaying()
            return
        }
        
        if !audioManager.isPaused && isThisPlaying{
            audioManager.pausePlaying()
            return
        }
        
        audioManager.stopPlaying()
        audioManager.startPlaying(filePath: viewModel.audioUrl)
    }
}

//struct VoiceNoteSectionShortNote_Previews: PreviewProvider {
//    static var previews: some View {
//        VoiceNoteSectionShortNote(noteId: "xd")
//            .frame(width: 200, height: 80)
//            .getFrameBorderPainted()
//    }
//}

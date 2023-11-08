//
//  RecordingPlayerView.swift
//  Your Notes
//
//  Created by Franco Marquez on 7/11/23.
//

import SwiftUI
import AVFoundation

struct RecordingPlayerView: View {
    
    var voicenotes: [NoteVoicenote]
    @StateObject private var audioPlayer = AudioRecordingPlayingManager()
    @State private var actualVoicenote : NoteVoicenote? = nil
    
    
    var body: some View {
        VStack{
            ForEach(voicenotes){voicenote in
                VoicenotePlayer(voicenote: voicenote,
                                actualVoicenote: $actualVoicenote,
                                audioPlayer: audioPlayer)
            }
        }
    }
}

fileprivate struct VoicenotePlayer: View{
    
    var voicenote : NoteVoicenote
    @Binding var actualVoicenote: NoteVoicenote?
    
    var asset: AVAsset{
        let documentDirectory = FileManagerHandler.getVoicenoteFolder(noteId: voicenote.note?.id?.uuidString)
        if let voicenoteURL = voicenote.voiceNoteDirectory{
            let finalURL = documentDirectory.appendingPathComponent(voicenoteURL)
            return AVAsset(url: finalURL)
        }
        return AVAsset()
    }
    
    @StateObject var audioPlayer : AudioRecordingPlayingManager
    @State private var audioSeconds : CGFloat = 0.0
    @State private var audioProgress : CGFloat = 0.0
    @State private var timeElapsed : CGFloat = 0.0
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var isThisPlaying: Bool{
        if actualVoicenote == nil{
            return false
        }
        
        if actualVoicenote == voicenote { return true }
        
        return false
    }
    
    var body: some View{
        HStack{
            Button {
                //dosthg
                doWhenPressed()
            } label: {
                IconPlayerVoicenote(isPaused: audioPlayer.isPaused,
                                    isThisPlaying: isThisPlaying)
            }
            
            ProgressBarVoicenote(isPlaying: audioPlayer.isPlaying,
                                 progress: audioProgress)
            
            DisplayTimeVoiceNote(audioInSeconds: self.audioSeconds)

        }
        .onChange(of: self.actualVoicenote, perform: { newValue in
            if newValue != self.voicenote{
                resetValues()
            }
        })
        .onReceive(self.timer, perform: { _ in
            if isThisPlaying{
                
                if audioPlayer.isPaused{
                    return
                }
                
                self.timeElapsed += 0.01
                self.audioProgress = timeElapsed / audioSeconds
                if self.timeElapsed > audioSeconds{
                    self.audioPlayer.stopPlaying()
                    resetValues()
                    self.actualVoicenote = nil
                    return
                }
            }
        })
        .onAppear{
            Task{
                do{
                    let audioTime = try await asset.load(.duration)
                    self.audioSeconds = CMTimeGetSeconds(audioTime)
                }catch{
                    Log.error("\(error.localizedDescription)")
                }
            }
        }
    }
    
    private func resetValues(){
        self.timeElapsed = 0.0
        self.audioProgress = 0.0
    }
    
    private func doWhenPressed(){
        
        if audioPlayer.isPlaying{
            if isThisPlaying{
                if audioPlayer.isPaused{
                    audioPlayer.resumePlaying()
                }else{
                    audioPlayer.pausePlaying()
                }
                return
            }
        }
        audioPlayer.startPlaying(asset: self.asset)
        self.actualVoicenote = self.voicenote
        
    }
}

//struct RecordingPlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordingPlayerView()
//    }
//}

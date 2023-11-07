//
//  VoiceRecordingPreview.swift
//  Your Notes
//
//  Created by Franco Marquez on 20/10/23.
//

import SwiftUI
import AVFoundation

struct VoiceRecordingPreview: View {
    
    @StateObject var audioManager: AudioRecordingPlayingManager
    
    var recording: RecordingPreview
    
    var isThisAudioPlaying : Bool {
        if audioManager.assets.isEmpty { return false }
        
        return recording == audioManager.actualRecordingPlaying
    }
    
    var iconName: String{
        if isThisAudioPlaying{
            if audioManager.isPaused{
                return GlobalValues.FilledIcons.Media.play
            }
            return GlobalValues.FilledIcons.Media.pause
        }
        return GlobalValues.FilledIcons.Media.play
    }
    
    @State private var audioPlayedProgress : CGFloat = 0.0
    @State private var totalAudioTimeInSeconds : CGFloat = 0
    @State private var timeElapsed : CGFloat = 0.0
    @State private var allowToPlay = false
    var timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        
        HStack(alignment: .center) {
            
            Button {
                
                if !allowToPlay{
                    return
                }
                
                if isThisAudioPlaying && !audioManager.isPaused{
                    audioManager.pausePlaying()
                    Log.info("Pausing voicenote")
                    return
                }
                
                if isThisAudioPlaying && audioManager.isPaused{
                    audioManager.resumePlaying()
                    Log.info("Resuming voicenote")
                    return
                }
                
                if audioManager.isPlaying && !isThisAudioPlaying {
                    audioManager.stopPlaying()
                    audioManager.startPlaying(tempRecording: recording)
                    return
                }
                
                Log.info("Trying to play \(recording.completeTemporalUrl)")
                audioManager.startPlaying(tempRecording: recording)
                
            } label: {
                IconPlayerVoicenote(isPaused: audioManager.isPaused,
                                    isThisPlaying: self.isThisAudioPlaying)
            }
            
            ProgressBarVoicenote(isPlaying: isThisAudioPlaying,
                                 progress: audioPlayedProgress)
            
            DisplayTimeVoiceNote(audioInSeconds: self.totalAudioTimeInSeconds)
            
        }
        .onAppear{
            Task{
                do{
                    let duration = try await recording.asset.load(.duration)
                    self.totalAudioTimeInSeconds = round(CMTimeGetSeconds(duration))
                    self.allowToPlay = true
                }catch{
                    Log.error("There was an error: \(error.localizedDescription)")
                }
            }
        }
        .onReceive(timer, perform: { _ in
            if isThisAudioPlaying{
                if !audioManager.isPaused{
                    timeElapsed += 0.001
                    audioPlayedProgress = CGFloat(timeElapsed / totalAudioTimeInSeconds)
                }
                
                if audioPlayedProgress > 1.0 {
                    audioManager.stopPlaying()
                    audioPlayedProgress = 0.0
                    timeElapsed = 0
                    Log.info("Playing stop")
                    return
                }
            }
        })
        .onChange(of: isThisAudioPlaying) { newValue in
            if !newValue{
                audioPlayedProgress = 0.0
            }
        }
    }
}

//struct VoiceRecordingPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        VoiceRecordingPreview(audioManager: AudioRecordingPlayingManager(),
//                              audioPathString: "file:///Users/francomMarquez/Library/Developer/CoreSimulator/Devices/9FC1EDE2-387C-4664-934C-CF219D8350B0/data/Containers/Data/Application/DD9DB1E6-E26E-41AE-88DE-C9343B5D60A3/Documents/VoiceNotes/CB5853ED-F1DC-42A0-B04C-5C115898F9B0/YN-20-10-23%20at%2017-46-29.m4a")
//    }
//}

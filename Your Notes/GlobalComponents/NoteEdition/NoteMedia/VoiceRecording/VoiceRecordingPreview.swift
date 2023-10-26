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
    var audioPathString : String
    
    var isThisAudioPlaying : Bool {
        
        return audioManager.isPlaying && 
        (audioPathString == audioManager.actualFilePlayingURLString)
        
    }
    
    var asset : AVAsset  {
        return AVAsset(url: URL(string: audioPathString)!)
    }
    
    @State private var timeAudioMinutes = 0
    @State private var timeAudioSeconds = 0
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
                
                if isThisAudioPlaying {
                    audioManager.stopPlaying()
                    return
                }
                
                if audioManager.isPlaying {
                    audioManager.stopPlaying()
                    audioManager.startPlaying(filePath: audioPathString)
                    return
                }
                audioManager.startPlaying(filePath: audioPathString)
                
            } label: {
                Image(systemName: isThisAudioPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
            }
            
            ZStack (alignment: .center){
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.gray)
                
                if isThisAudioPlaying{
                    GeometryReader{ geo in
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(ColorManager.primaryColor)
                            .padding(.trailing, geo.size.width * (1 - audioPlayedProgress))
                            .animation(.linear, value: audioPlayedProgress)
                    }
                }
            }
            .frame(height: 10)
            
            Text("\(String(format: "%02d", timeAudioMinutes)):\(String(format: "%02d", timeAudioSeconds))")
                .font(.system(size: 18))
            
        }
        .onAppear{
            Task{
                do{
                    let duration = try await asset.load(.duration)
                    self.totalAudioTimeInSeconds = round(CMTimeGetSeconds(duration))
                    self.timeAudioMinutes = Int(self.totalAudioTimeInSeconds / 60)
                    self.timeAudioSeconds = Int(round(self.totalAudioTimeInSeconds.truncatingRemainder(dividingBy: 60.0)))
                    self.allowToPlay = true
                }catch{
                    Log.error("There was an error: \(error.localizedDescription)")
                }
            }
        }
        .onReceive(timer, perform: { _ in
            if isThisAudioPlaying {
                
                if audioPlayedProgress > 1.0 {
                    audioManager.stopPlaying()
                    audioPlayedProgress = 0.0
                    timeElapsed = 0
                    Log.info("Playing stop")
                    return
                }
                timeElapsed += 0.001
                audioPlayedProgress = CGFloat(timeElapsed / totalAudioTimeInSeconds)
                Log.info("\(audioPlayedProgress)")
            }
        })
        
    }
}

//struct VoiceRecordingPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        VoiceRecordingPreview(audioManager: AudioRecordingPlayingManager(),
//                              audioPathString: "file:///Users/francomMarquez/Library/Developer/CoreSimulator/Devices/9FC1EDE2-387C-4664-934C-CF219D8350B0/data/Containers/Data/Application/DD9DB1E6-E26E-41AE-88DE-C9343B5D60A3/Documents/VoiceNotes/CB5853ED-F1DC-42A0-B04C-5C115898F9B0/YN-20-10-23%20at%2017-46-29.m4a")
//    }
//}

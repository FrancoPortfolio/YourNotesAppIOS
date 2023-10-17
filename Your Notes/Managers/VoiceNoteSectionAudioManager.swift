//
//  VoiceNoteSectionAudioManager.swift
//  Your Notes
//
//  Created by Franco Marquez on 17/10/23.
//

import Foundation
import AVFoundation

class VoiceNoteSectionAudioManager: NSObject, ObservableObject, AVAudioPlayerDelegate{
    
    var audioRecorder : AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    
    @Published var isPlaying : Bool = false
    
    override init(){
        super.init()
    }
    
    func startPlaying(fileName : String?) {
        
        guard let file = fileName else { return }
        
        var url = getFileURL(fileName: file)
        
        let playSession = AVAudioSession.sharedInstance()
            
        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing failed in Device")
        }
            
        do {
            audioPlayer = try AVAudioPlayer(contentsOf : url)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            isPlaying = true
        } catch {
            print("Playing Failed")
        }
                
    }

    func stopPlaying(){
        audioPlayer.stop()
        isPlaying = false
    }
    
    func getFileURL(fileName: String) -> URL{
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent(fileName)
        
        return soundURL
    }
    
}

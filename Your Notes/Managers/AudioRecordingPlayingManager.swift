//
//  VoiceNoteSectionAudioManager.swift
//  Your Notes
//
//  Created by Franco Marquez on 17/10/23.
//

import Foundation
import AVFoundation

class AudioRecordingPlayingManager: NSObject, ObservableObject, AVAudioPlayerDelegate{
    
    var audioRecorder : AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    
    @Published var isPlaying : Bool = false
    @Published var isPaused : Bool = false
    @Published var isRecording : Bool = false
    @Published var assets = [RecordingPreview]()
    var actualRecordingPlaying : RecordingPreview? = nil
    var actualFilePlayingURLString : String = ""
   
    override init(){
        super.init()
    }
}

//Recording methods
extension AudioRecordingPlayingManager {
    
    func setupRecording(){
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            Log.error("Can not setup the Recording")
        }
    }
    
    func startRecording(atUrl: URL){
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: atUrl, settings: settings)
            Log.info("Recording on \(atUrl)")
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            isRecording = true
        } catch {
            Log.error("Failed to Setup the Recording")
        }
    }
    
    
    func stopRecording(){
        audioRecorder.stop()
        isRecording = false
        Log.info("Recording stopped")
    }
    
    func stopRecordingReturningPath() -> String {
        audioRecorder.stop()
        Log.info("Recording stopped")
        isRecording = false
        return "pathToReturn"
    }
}

//Playing methods
extension AudioRecordingPlayingManager{
    
    func startPlaying(filePath : String) {
        
        guard let url = URL(string: filePath) else {
            Log.error("Bad url")
            return
        }
        
//        if audioPlayer != nil{
//            stopPlaying()
//        }
        
        do {
            Log.info("Trying to fetch url: \(url.absoluteString)")
            let _ = try url.checkResourceIsReachable()
        } catch {
            Log.error("Not able to load file \(error.localizedDescription)")
        }
        
        let playSession = AVAudioSession.sharedInstance()
            
        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            Log.error("Playing failed in Device")
        }
            
        do {
            audioPlayer = try AVAudioPlayer(contentsOf : url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            actualFilePlayingURLString = filePath
            isPlaying = true
        } catch {
            Log.error("Playing Failed, \(error)")
        }      
    }
    
    func startPlaying(asset: AVAsset){
        
        guard let url = asset.value(forKey: "URL") else{
            Log.error("No url found")
            return
        }
        
        let urlString = String(describing: url)
        
        startPlaying(filePath: urlString)
    }
    
    func startPlaying(tempRecording: RecordingPreview){
        
        
        guard let url = URL(string: tempRecording.completeTemporalUrl) else {
            return
        }
        
        if audioPlayer != nil{
            stopPlaying()
        }
        
        let playSession = AVAudioSession.sharedInstance()
        
        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            Log.error("Playing failed in Device \(error.localizedDescription)")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            actualRecordingPlaying = tempRecording
            isPlaying = true
        } catch {
            Log.error("Playing Failed, \(error)")
        }
    }
    
    func pausePlaying(){
        audioPlayer.pause()
        isPaused = true
    }
    
    func resumePlaying(){
        audioPlayer.play()
        isPaused = false
    }

    func stopPlaying(){
        audioPlayer.stop()
        isPlaying = false
        isPaused = false
        actualRecordingPlaying = nil
        actualFilePlayingURLString = ""
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.stopPlaying()
        Log.info("Did finished playing")
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        Log.error(error?.localizedDescription ?? "Unknown error on player")
    }
}

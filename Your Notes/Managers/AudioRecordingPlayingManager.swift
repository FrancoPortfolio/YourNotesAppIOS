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
    @Published var isRecording : Bool = false
    @Published var tempURLOfLastFileRecording : String = ""
    @Published var assets = [Recording]()
    var actualFilePlayingURLString : String = ""
    let fileManager = FileManager.default
   
    override init(){
        super.init()
    }
}

//File Management
extension AudioRecordingPlayingManager {
    func checkBaseFolderExists(basePath: URL) -> Bool{
        do{
            
            let resourceValues = try basePath.resourceValues(forKeys: [.isDirectoryKey])
            if let isDirectory = resourceValues.isDirectory {
                if isDirectory {
                    return true
                }
                return false
            } else {
                return false
            }
        } catch {
            Log.error("An error ocurred\(error.localizedDescription)")
            return false
        }
    }
    
    func createBaseFolder(basePath: URL){
        do{
            Log.info("Trying to create folder")
            try fileManager.createDirectory(at: basePath, withIntermediateDirectories: true)
            Log.info("Folder created")
        } catch {
            Log.error("An error ocurred: \(error)")
            return
        }
    }
    
    func createBaseFolderForRecording(noteId: String){
        let basePath = getBaseFolderURL(noteId: noteId)
        
        if !checkBaseFolderExists(basePath: basePath){
            createBaseFolder(basePath: basePath)
        }
    }
    
    func getBaseFolderURL(noteId: String) -> URL{
        var basePath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        basePath = basePath.appendingPathComponent("VoiceNotes")
        basePath = basePath.appendingPathComponent(noteId)
        return basePath
    }
    
    func getFileURL(fileName: String) -> URL{
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent(fileName)
        
        return soundURL
    }
    
    func getFileURL(filePath: String) -> URL{
        
        return URL(string: filePath)!
    }
    
    func eraseFileAtURL(urlString: String){
        if let path = URL(string: urlString){
            do {
                try fileManager.removeItem(at: path)
                Log.info("File erased")
            } catch  {
                Log.error("Error deleting file at \(path) : \(error)")
            }
        }
    }
    
    func eraseLastRecording(){
        eraseFileAtURL(urlString: self.tempURLOfLastFileRecording)
        self.tempURLOfLastFileRecording = ""
    }
}

//Recording methods
extension AudioRecordingPlayingManager {
    func startRecording(noteId id : String){
        
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            Log.error("Can not setup the Recording")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YY 'at' HH-mm-ss"
        
        let basePath = getBaseFolderURL(noteId: id)
        
        let path = basePath.appendingPathComponent("YN-\(dateFormatter.string(from: Date())).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: path, settings: settings)
            Log.info("Recording on \(path)")
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            self.tempURLOfLastFileRecording = path.absoluteString
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
        let pathToReturn = self.tempURLOfLastFileRecording
        self.tempURLOfLastFileRecording = ""
        return pathToReturn
    }
}

//Playing methods
extension AudioRecordingPlayingManager{
    func startPlaying(fileName : String?) {
        
        guard let file = fileName else { return }
        
        let url = getFileURL(fileName: file)
        
        let playSession = AVAudioSession.sharedInstance()
            
        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            Log.error("Playing failed in Device")
        }
            
        do {
            audioPlayer = try AVAudioPlayer(contentsOf : url)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            isPlaying = true
        } catch {
            Log.error("Playing Failed")
        }
                
    }
    
    func startPlaying(filePath : String) {
        
        if self.isPlaying {
            self.isPlaying = false
        }
        
        let url = getFileURL(filePath: filePath)
        
        let playSession = AVAudioSession.sharedInstance()
            
        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            Log.error("Playing failed in Device")
        }
            
        do {
            audioPlayer = try AVAudioPlayer(contentsOf : url)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            actualFilePlayingURLString = filePath
            isPlaying = true
        } catch {
            Log.error("Playing Failed")
        }
                
    }

    func stopPlaying(){
        audioPlayer.stop()
        isPlaying = false
    }
}

struct Recording{
    let id = UUID().uuidString
    let dataUrl : String
    let asset : AVAsset
}

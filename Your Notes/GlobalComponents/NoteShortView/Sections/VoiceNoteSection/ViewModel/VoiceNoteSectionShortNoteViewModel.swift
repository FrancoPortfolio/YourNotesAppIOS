//
//  VoiceNoteSectionShortNoteViewModel.swift
//  Your Notes
//
//  Created by Franco Marquez on 27/10/23.
//

import Foundation
import SwiftUI
import AVFoundation

class VoiceNoteSectionShortNoteViewModel: ObservableObject{
    
    private var audioUrl: String = ""
    @ObservedObject var audioPlayer = AudioRecordingPlayingManager()
    
    init(voicenoteSet: NSSet?){
        let voiceNoteArray = turnSetToNoteVoicenoteArray(set: voicenoteSet)
        
        if let firstVoicenote = voiceNoteArray?.first, let audioUrlString = firstVoicenote.voiceNoteDirectory {
            self.audioUrl = audioUrlString
        }
    }
    
    func startPlaying(){
        audioPlayer.startPlaying(filePath: audioUrl)
    }
    
    func pausePlaying(){
        audioPlayer.pausePlaying()
    }
    
    private func turnSetToNoteVoicenoteArray(set: NSSet?) -> [NoteVoicenote]?{
        
        guard let coreDataSet = set else { return nil }
        
        let voicenoteArray = DataManager.turnSetToArray(set: coreDataSet, typeToConvert: NoteVoicenote.self)
        
        return voicenoteArray
    }
}

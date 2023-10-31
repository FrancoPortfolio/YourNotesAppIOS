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
    
    @Published var audioUrl: String = ""
    private var fileHandler = FileManagerHandler()
    
    init(voicenoteSet: NSSet?, noteId: String){
        let voiceNoteArray = turnSetToNoteVoicenoteArray(set: voicenoteSet)
        
        if let firstVoicenote = voiceNoteArray?.first, let audioUrlString = firstVoicenote.voiceNoteDirectory {
            let baseURL = FileManagerHandler.getVoicenoteFolder(noteId: noteId)
            
            self.audioUrl = baseURL.appendingPathComponent(audioUrlString).absoluteString
        }
    }
    
    private func turnSetToNoteVoicenoteArray(set: NSSet?) -> [NoteVoicenote]?{
        
        guard let coreDataSet = set else { return nil }
        
        let voicenoteArray = DataManager.turnSetToArray(set: coreDataSet, typeToConvert: NoteVoicenote.self)
        
        return voicenoteArray
    }
}

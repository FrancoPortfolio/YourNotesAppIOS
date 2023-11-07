//
//  RecordingPlayerView.swift
//  Your Notes
//
//  Created by Franco Marquez on 7/11/23.
//

import SwiftUI

struct RecordingPlayerView: View {
    
    @StateObject private var audioPlayer = AudioRecordingPlayingManager()
    @State private var actualVoicenote : NoteVoicenote? = nil
    
    
    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

struct RecordingPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingPlayerView()
    }
}

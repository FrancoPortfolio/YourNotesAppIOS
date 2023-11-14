//
//  RecordingPlayerView.swift
//  Your Notes
//
//  Created by Franco Marquez on 7/11/23.
//

import SwiftUI
import AVFoundation

struct RecordingPlayerView: View {
    
    @Binding var voicenotes: [NoteVoicenote]
    @StateObject private var audioPlayer = AudioRecordingPlayingManager()
    @State private var actualVoicenote : NoteVoicenote? = nil
    @State private var showVoiceRecordingSheet : Bool = false
    var noteId : String
    var isEditing : Bool = false
    @Binding var temporalFilenames : [String]
    
    
    var body: some View {
        VStack{
            if isEditing || !self.voicenotes.isEmpty{
                HStack{
                    Text(GlobalValues.Strings.Subtitles.voicenotes)
                        .extendedNoteSubtitle()
                }
                .padding(.top)
            }
            
            VStack{
                if !self.voicenotes.isEmpty{
                    VStack(spacing: 10){
                        ForEach(voicenotes){voicenote in
                            VoicenotePlayer(noteId: self.noteId,
                                            voicenote: voicenote,
                                            actualVoicenote: $actualVoicenote,
                                            isEditing: isEditing,
                                            audioPlayer: audioPlayer){ voicenote in
                                if let index = voicenotes.firstIndex(of: voicenote){
                                    withAnimation(.linear){
                                        let voicenote = voicenotes.remove(at: index)
                                        DataManager.deleteObject(object: voicenote)
                                    }
                                }
                            }
                        }
                    }
                }
                if isEditing{
                    Button {
                        self.showVoiceRecordingSheet.toggle()
                    } label: {
                        Label("Add voicenote", systemImage: GlobalValues.FilledIcons.micIcon)
                            .expandedDashedLabel()
                    }
                }

            }
            .padding(.vertical)
            
        }
        .sheet(isPresented: self.$showVoiceRecordingSheet) {
            VoiceRecordingView(noteId: self.noteId) { filename in
                self.addNotePathToNoteArray(filename: filename)
            }
        }
    }
    
    private func addNotePathToNoteArray(filename: String){
        
        let url = filename
        let noteVoiceNoteEntity = NoteVoicenote(context: DataManager.standard.container.viewContext)
        
        noteVoiceNoteEntity.id = UUID()
        noteVoiceNoteEntity.voiceNoteDirectory = url
        
        self.voicenotes.append(noteVoiceNoteEntity)
        self.temporalFilenames.append(filename)
    }
}

fileprivate struct VoicenotePlayer: View{
    
    var noteId: String
    var voicenote : NoteVoicenote
    @Binding var actualVoicenote: NoteVoicenote?
    var isEditing : Bool
    
    var asset: AVAsset{
        let documentDirectory = FileManagerHandler.getVoicenoteFolder(noteId: voicenote.note?.id?.uuidString ?? noteId)
        if let voicenoteURL = voicenote.voiceNoteDirectory{
            let finalURL = documentDirectory.appendingPathComponent(voicenoteURL)
            return AVAsset(url: finalURL)
        }
        return AVAsset()
    }
    
    @StateObject var audioPlayer : AudioRecordingPlayingManager
    var doWhenErasedPressed : (_ note: NoteVoicenote) -> ()
    @State private var audioSeconds : CGFloat = 0.0
    @State private var audioProgress : CGFloat = 0.0
    @State private var timeElapsed : CGFloat = 0.0
    var timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    
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
            
            if isEditing{
                Button{
                    doWhenErasedPressed(voicenote)
                }label: {
                    //erase
                    Image(systemName: GlobalValues.NoFilledIcons.xButton)
                        .generalIconButton()
                }
            }

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
                
                self.timeElapsed += 0.001
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

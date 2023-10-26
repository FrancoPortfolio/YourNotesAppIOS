//
//  VoiceRecordingView.swift
//  Your Notes
//
//  Created by Franco Marquez on 19/10/23.
//

import SwiftUI

struct VoiceRecordingView: View {
    
    var noteId: String
    @Binding var recordingsNames : [String]
    
    @StateObject private var audioPlayerManager = AudioRecordingPlayingManager()
    @State private var textTimerSeconds = 0
    @State private var textTimerMinutes = 0
    @State private var showExtraButtons = false
    
    var doWhenSavePressed : (String) -> ()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader{ geo in
            ZStack {
                
                ColorManager.backgroundColor
                    .ignoresSafeArea()
                    .zIndex(1)
                
                VoiceRecordingBase()
                    .foregroundStyle(ColorManager.secondaryColor)
                    .ignoresSafeArea()
                    .zIndex(2)
                
                //Record Button
                Group {
                    Button{
                        if audioPlayerManager.isRecording{
                            audioPlayerManager.stopRecording()
                            return
                        }
                        audioPlayerManager.startRecording(noteId: noteId)
                    }label: {
                        Image(systemName: audioPlayerManager.isRecording ? "square.circle.fill" : "mic.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(ColorManager.primaryColor)
                            .frame(width: geo.size.width * 0.3)
                    }
                } .offset(y: geo.size.height * 0.3)
                    .zIndex(2)
                
                //Timer
                Group {
                    Text("\(String(format: "%02d", textTimerMinutes)):\(String(format: "%02d", textTimerSeconds))")
                        .font(.system(size: 60))
                        .fontWeight(.bold)
                        .onReceive(timer, perform: { _ in
                            if audioPlayerManager.isRecording {
                                if textTimerSeconds + 1 == 60{
                                    textTimerSeconds = 0
                                    textTimerMinutes += 1
                                } else {
                                    textTimerSeconds += 1
                                }
                            }
                        })
                        .onChange(of: audioPlayerManager.isRecording) { newValue in
                            if !newValue {
                                showExtraButtons = true
                            }
                        }
                    
                }.offset(y: geo.size.height * 0.075)
                    .zIndex(3)
                
                if showExtraButtons {
                    Group{
                        HStack{
                            Button(action: {
                                self.textTimerMinutes = 0
                                self.textTimerSeconds = 0
                                self.audioPlayerManager.eraseLastRecording()
                                self.showExtraButtons = false
                            }, label: {
                                Text("Erase")
                                    .font(.system(size: 25))
                                    .fontWeight(.bold)
                                    .padding()
                            })
                            
                            Spacer()
                            
                            Button(action: {
                                
                                let lastFilePath = self.audioPlayerManager.tempURLOfLastFileRecording
                                
                                self.audioPlayerManager.tempURLOfLastFileRecording = ""
                                
                                doWhenSavePressed(lastFilePath)
                            }, label: {
                                Text("Save")
                                    .font(.system(size: 25))
                                    .fontWeight(.bold)
                                    .padding()
                            })
                        }
                        .padding(.horizontal)
                    }
                    .offset(y: geo.size.height * 0.45)
                    .zIndex(3)
                }
            }
        }
        .onAppear(perform: {
            self.audioPlayerManager.createBaseFolderForRecording(noteId: self.noteId)
        })
        .onDisappear(perform: {
            if self.audioPlayerManager.isRecording {
                self.audioPlayerManager.stopRecording()
                self.audioPlayerManager.eraseLastRecording()
                return
            }
            
            if self.audioPlayerManager.tempURLOfLastFileRecording != "" {
                self.audioPlayerManager.eraseLastRecording()
            }
            
        })
    }
}

fileprivate struct VoiceRecordingBase: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.height * 0.8))
        
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.height * 0.8),
                          control: CGPoint(x: rect.midX, y: rect.height * 0.5))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        
        
        return path
    }
    
}

//struct VoiceRecordingView_Previews: PreviewProvider {
//    static var previews: some View {
//        VoiceRecordingView(noteId: "XD", recordingsNames: .constant([])){ _ in }
//    }
//}

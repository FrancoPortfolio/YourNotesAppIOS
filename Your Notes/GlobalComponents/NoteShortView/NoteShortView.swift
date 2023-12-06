//
//  NoteView.swift
//  Your Notes
//
//  Created by Franco Marquez on 16/10/23.
//

import SwiftUI

struct NoteShortView: View {
    
    @State private var showItself = true
    @State private var showPopMenu = false
    @State private var reduceItself = false
    @GestureState private var isBeingPressed = false
    @StateObject var audioManager: AudioRecordingPlayingManager
    
    var note : Note
    
    private var isPinned : Bool {
        return note.isPinned
    }
    
    private var isFavorite: Bool{
        return note.isFavorite
    }
    
    private var isTagged: Bool{
        if note.tag?.tag != nil {
            return true
        }
        return false
    }
    
    private var contentSectionsValues: [contentSections]{
        
        var sections : [contentSections] = []
        
        if note.text != nil && !(note.text?.isEmpty ?? true){
            sections.append(.text)
        }
        
        if let images = note.images{
            if images.count != 0{
                sections.append(.images)
            }
        }
        
        if let subtasks = note.subtasks{
            if subtasks.count != 0{
                sections.append(.subtasks)
            }
        }
        
        if let voicenotes = note.voicenotes{
            if voicenotes.count != 0{
                sections.append(.voicenotes)
            }
        }
        
        if note.drawing != nil{
            sections.append(.drawing)
        }
        
        return sections
    }
    
    
    var body: some View {
        ZStack{
            if showItself{
                
                if let colorHex = note.color?.colorHex{
                    Color.init(hex: colorHex).frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                VStack(spacing: 0){
                    //Pin Icon
                    NoteShortHeader(note: note,
                                    isPinned: isPinned,
                                    isFavorite: isFavorite,
                                    isTagged: isTagged)
                    //Top Left Indicators
                    NoteShortIndicators(isFavorite: isFavorite,
                                        isTagged: isTagged,
                                        isPinned: isPinned,
                                        contentSections: contentSectionsValues)
                    //Sections to show on note, max of 2 following array order
                    NoteShortBody(note: note,
                                  audioManager: audioManager,
                                  isPinned: isPinned,
                                  isFavorite: isFavorite)
                }
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(content: {
            NavigationLink(value: HomeRoutingDestinations.expandNote(noteId: note.id!.uuidString)) {
                Rectangle()
                    .fill(Color.clear)
            }
        })
        .cornerRadius(10, corners: isPinned ? [.bottomLeft,.bottomRight,.topLeft] : .allCorners)
        .onAppear{
            showItself = true
        }
        .onDisappear{
            showItself = false
        }
        .shadow(radius: 3)
        .scaleEffect(reduceItself ? 0.95 : 1.0)
        .onTapGesture {
            withAnimation {
                reduceItself  = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                    withAnimation {
                        reduceItself = false
                    }
                }
            }
        }
    }
}

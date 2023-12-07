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
    @GestureState private var isBeingPressed = false
    @StateObject var audioManager: AudioRecordingPlayingManager
    @Binding var navPath : NavigationPath
    
    var note : Note
    @StateObject var viewModel: HomeViewModel
    
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
        .cornerRadius(10, corners: isPinned ? [.bottomLeft,.bottomRight,.topLeft] : .allCorners)
        .onAppear{
            showItself = true
        }
        .onDisappear{
            showItself = false
        }
        .shadow(radius: 3)
        .modifier(TapAndLongPressModifier(tapAction: {
            navPath.append(HomeRoutingDestinations.expandNote(noteId: note.id!.uuidString))
        }, longPressAction: {
            self.showPopMenu = true
        }))
        .confirmationDialog("xd", isPresented: self.$showPopMenu) {
            Button("\(note.isFavorite ? "Unmark" : "Mark" ) as Favorite", role: .none) {
                if note.isFavorite{
                    viewModel.unmarkAsFavorite(note: note)
                    return
                }
                viewModel.markAsFavorite(note: note)
            }
            Button("\(note.isPinned ? "Unpin" : "Pin" ) note", role: .none) {
                if note.isPinned{
                    viewModel.unmarkAsPinned(note: note)
                    return
                }
                viewModel.markAsPinned(note: note)
            }
        }

        
    }
}

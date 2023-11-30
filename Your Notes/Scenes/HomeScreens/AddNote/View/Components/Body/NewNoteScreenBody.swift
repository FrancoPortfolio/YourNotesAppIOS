//
//  NewNoteScreenBody.swift
//  Your Notes
//
//  Created by Franco Marquez on 14/11/23.
//

import SwiftUI

struct NewNoteScreenBody: View {
    
    @StateObject var viewModel: AddNewNoteViewModel
    
    var body: some View {
        VStack{
            
            NoteFormTextField(noteText: $viewModel.noteTitle,
                              placeholderText: "Note Title")
            
            NoteFormTextField(noteText: $viewModel.noteText,
                              placeholderText: "Note Text",
                              shouldExpand: true)
            
            NewNoteScreenBodySubtasks(viewModel: self.viewModel)
            
            NewNoteScreenBodyImages(viewModel: self.viewModel)
            
            RecordingPlayerView(voicenotes: $viewModel.audioNotes,
                                noteId: viewModel.noteId,
                                isEditing: true)
            
            NewNoteScreenBodyDrawing(viewModel: viewModel)
            
        }
        .onDisappear{
            DataManager.standard.eraseUncommitedChanges()
        }
    }
}

//struct NewNoteScreenBody_Previews: PreviewProvider {
//    static var previews: some View {
//        NewNoteScreenBody()
//    }
//}

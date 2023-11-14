//
//  DrawingSectionShortNoteView.swift
//  Your Notes
//
//  Created by Franco Marquez on 30/10/23.
//

import SwiftUI

struct DrawingSectionShortNoteView: View {
    
    @StateObject private var viewModel: DrawingSectionShortNoteViewModel
    
    init(noteDrawing: NoteDrawing?) {
        self._viewModel = StateObject(wrappedValue: DrawingSectionShortNoteViewModel(drawingNote: noteDrawing))
    }
    
    var body: some View {
        Image(uiImage: viewModel.uiImage)
            .resizable()
            .clipped()
            .scaledToFill()
            .frame(maxWidth: .infinity)
    }
}

//struct DrawingSectionShortNoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        DrawingSectionShortNoteView()
//    }
//}

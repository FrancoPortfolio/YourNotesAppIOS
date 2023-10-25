//
//  NewNoteColorSectionView.swift
//  Your Notes
//
//  Created by Franco Marquez on 24/10/23.
//

import SwiftUI

struct NewNoteColorSectionView: View {
    
    @StateObject var viewModel = NewNoteColorSectionViewModel()
    @Binding var selectedColorId : String
    
    var body: some View {
        Group{
            Text("Select color")
                .newNoteSubtitle()
            
            NoteColorSelector(colorList: viewModel.highlightColors, selectedColorId: $selectedColorId)
        }
    }
}

#Preview {
    NewNoteColorSectionView(selectedColorId: .constant("d6eeb4b3-d8ac-4fc2-a58d-85a5475d6cd6"))
}

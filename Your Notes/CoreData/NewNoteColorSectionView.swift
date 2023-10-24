//
//  NewNoteColorSectionView.swift
//  Your Notes
//
//  Created by Franco Marquez on 24/10/23.
//

import SwiftUI

struct NewNoteColorSectionView: View {
    
    
    
    var body: some View {
        Group{
            Text("Select color")
                .newNoteSubtitle()
            
//            NoteColorSelector(colorList: defaultColors,
//                              selectedColor: $viewModel.selectedColorHex)
        }
    }
}

#Preview {
    NewNoteColorSectionView()
}

//
//  TagSection.swift
//  Your Notes
//
//  Created by Franco Marquez on 24/10/23.
//

import SwiftUI

struct NewNoteTagSectionView: View {
    
    @StateObject var viewModel = NewNoteTagSectionViewViewModel()
    
    var body: some View {
        Group {
            Text("Select tag")
                .newNoteSubtitle()
            
            NoteTagSelector(tags: $viewModel.tags){ newTag in
                viewModel.saveNewTag(tagName: newTag)
            }
            
        }
        .frame(maxWidth: .infinity)
        
    }
}

#Preview {
    NewNoteTagSectionView()
}

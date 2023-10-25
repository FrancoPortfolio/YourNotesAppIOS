//
//  TagSection.swift
//  Your Notes
//
//  Created by Franco Marquez on 24/10/23.
//

import SwiftUI

struct NewNoteTagSectionView: View {
    
    @StateObject var viewModel = NewNoteTagSectionViewViewModel()
    @Binding var actualTag : UUID?
    
    var body: some View {
        Group {
            Text("Select tag")
                .newNoteSubtitle()
            
            NoteTagSelector(actualTag: $actualTag,tags: $viewModel.tags){ newTag in
                viewModel.saveNewTag(tagName: newTag)
            }
            
        }
        .frame(maxWidth: .infinity)
        
    }
}

struct NewNoteTagSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NewNoteTagSectionView(actualTag: .constant(nil))
    }
}

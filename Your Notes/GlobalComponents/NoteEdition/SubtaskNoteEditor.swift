//
//  SubtaskNoteEditor.swift
//  Your Notes
//
//  Created by Franco Marquez on 18/10/23.
//

import SwiftUI

struct SubtaskNoteEditor: View {
    
    var subtask: Subtask
    
    var body: some View {
        
        HStack{
            
            HStack {
                Image(systemName: subtask.isChecked ? GlobalValues.NoFilledIcons.checkmarkSquare : GlobalValues.NoFilledIcons.square)
            }
            
            Text(subtask.name)
                .frame(maxWidth: .infinity, alignment: .leading)
            
           
        }
        .font(.title2)
    }
    
}

//struct SubtaskNoteEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        SubtaskNoteEditor(
//            subtask: Subtask(name: "Buy eggs",
//                             isChecked: false)
//        )
//    }
//}

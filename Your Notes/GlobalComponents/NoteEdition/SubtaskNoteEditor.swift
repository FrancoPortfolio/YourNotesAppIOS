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
                Image(systemName: "line.3.horizontal")
                
                Image(systemName: subtask.isChecked ? "checkmark.square.fill" : "square")
            }
            
            Text(subtask.name)
                .frame(maxWidth: .infinity, alignment: .leading)
            
           
        }
        
    }
    
}

struct SubtaskNoteEditor_Previews: PreviewProvider {
    static var previews: some View {
        SubtaskNoteEditor(
            subtask: Subtask(name: "Buy eggs",
                             isChecked: false)
        )
    }
}

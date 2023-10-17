//
//  ToDoSection.swift
//  Your Notes
//
//  Created by Franco Marquez on 17/10/23.
//

import SwiftUI

struct ToDoSectionShortNote: View {
    @Binding var todoList: [ToDo]?
    
    var body: some View {
        
        VStack{
            if let _ = todoList{
                if !todoList!.isEmpty{
                    
                    ForEach(0..<Int((min(2,todoList!.count))), id: \.self){ index in
                        
                        Button {
                            todoList![index].isChecked.toggle()
                        } label: {
                            HStack{
                                Image(systemName: todoList![index].isChecked ? "checkmark.square" : "square")
                                Text(todoList![index].name)
                                Spacer()
                            }
                            .foregroundStyle(Color(uiColor: .black))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ToDoSectionShortNote(todoList: .constant(nil))
}

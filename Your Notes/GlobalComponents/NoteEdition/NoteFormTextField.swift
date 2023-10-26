//
//  NoteTextField.swift
//  Your Notes
//
//  Created by Franco Marquez on 17/10/23.
//

import SwiftUI

struct NoteFormTextField: View {
    
    @Binding var noteText: String
    var showBackground: Bool = true
    var placeholderText: String = "Note text"
    
    var body: some View {
        
        VStack {
            TextField(placeholderText, text: $noteText)
            Line()
                .stroke(ColorManager.primaryColor, lineWidth: 2)
                .frame(height: 1)
        }
        .padding(showBackground ? 15 : 0)
        .padding(.top, showBackground ? 15 : 0)
        .padding(.bottom,showBackground ? 25 : 0)
        .background{
            
            if showBackground {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.gray.opacity(0.2))
            }
        }
            
    }
}

struct Line: Shape{
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        path.move(to: rect.origin)
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        
        path.closeSubpath()
        
        return path
    }
    
}
//
//struct NoteFormTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        Group{
//            NoteFormTextField(noteText: .constant(""))
//                .preferredColorScheme(.dark)
//            
//            NoteFormTextField(noteText: .constant(""), showBackground: false)
//                .preferredColorScheme(.dark)
//        }
//    }
//}

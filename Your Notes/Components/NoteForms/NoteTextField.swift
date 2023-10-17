//
//  NoteTextField.swift
//  Your Notes
//
//  Created by Franco Marquez on 17/10/23.
//

import SwiftUI

struct NoteTextField: View {
    
    @Binding var noteText: String
    
    var body: some View {
        
        VStack {
            TextField("Note text", text: $noteText)
            Line()
                .stroke(ColorManager.primaryColor, lineWidth: 2)
                .frame(height: 1)
        }
        .padding()
        .padding(.top)
        .padding(.bottom,25)
        .background{
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.gray.opacity(0.2))
        }
            
    }
}

fileprivate struct Line: Shape{
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        path.move(to: rect.origin)
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        
        path.closeSubpath()
        
        return path
    }
    
}

#Preview {
    NoteTextField(noteText: .constant(""))
        .preferredColorScheme(.dark)
}

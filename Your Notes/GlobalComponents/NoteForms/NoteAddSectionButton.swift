//
//  NoteAddSectionButton.swift
//  Your Notes
//
//  Created by Franco Marquez on 17/10/23.
//

import SwiftUI

struct NoteAddSectionButton: View {
    
    var iconName: String = "camera.fill"
    var doOnButtonPressed : () -> ()
    
    var body: some View {
        
        Button(action: {
            doOnButtonPressed()
        }, label: {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding(23)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.gray.opacity(0.2))
                }
                .overlay {
                    GeometryReader(content: { geometry in
                        Image(systemName: "plus")
                            .padding(5)
                    })
                }
        })
    }
}

#Preview {
    NoteAddSectionButton() {}
}

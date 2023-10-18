//
//  NewNoteColorSelector.swift
//  Your Notes
//
//  Created by Franco Marquez on 18/10/23.
//

import SwiftUI

struct NoteColorSelector: View {
    
    var colorList: [String]
    @State private var presentColorEditor: Bool = false
    @Binding var selectedColor: String
    
    var body: some View {
        ScrollView(.horizontal){
            HStack (spacing: 30){
                
                Button(action: {
                    presentColorEditor = true
                }, label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 33, height: 33)
                })
                
                
                HStack (spacing: 15){
                    ForEach(colorList,id: \.self){ colorHex in
                        
                        ColorSphere(colorHex: colorHex, selectedColor: $selectedColor)
                            .frame(width: 30, height: 30)
                    }
                }
                
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .sheet(isPresented: $presentColorEditor, content: {
                    Text("Color editor")
                })
        }
    }
}

fileprivate struct ColorSphere: View {
    
    var colorHex: String
    @Binding var selectedColor: String
    
    var body: some View {
        
        Button(action: {
            selectedColor = colorHex
        }, label: {
            Color(hex: colorHex)
                .clipShape(Circle())
                .shadow(radius: 3)
                .overlay {
                    if selectedColor == colorHex {
                        Circle()
                            .stroke(ColorManager.textColor,lineWidth: 0.8)
                    }
                }
        })
        
        
    }
}

#Preview {
    NavigationStack {
        NoteColorSelector(colorList: ["#FFFFFF","#FF0000","#00FF00","#008000","#0000FF","#800080"], selectedColor: .constant("#FFFFFF"))
            .navigationDestination(for: AddNoteDestinations.self) { value in
                Text("Color")
            }
    }
}

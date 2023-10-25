//
//  NewNoteColorSelector.swift
//  Your Notes
//
//  Created by Franco Marquez on 18/10/23.
//

import SwiftUI

struct NoteColorSelector: View {
    
    var colorList: [NoteHighlightColor]
    @State private var presentColorEditor: Bool = false
    @Binding var selectedColorId: String
    var doOnRefreshColors : () -> ()
    
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
                    ForEach(colorList,id: \.self){ noteColor in
                        
                        ColorSphere(noteColor: noteColor, selectedColorId: $selectedColorId)
                            .frame(width: 30, height: 30)
                    }
                }
                
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .sheet(isPresented: $presentColorEditor, onDismiss: {
                doOnRefreshColors()
            }, content: {
                NewColorEditor()
            .presentationDetents([.fraction(0.5)])
            })
        }
    }
}

fileprivate struct ColorSphere: View {
    
    var noteColor: NoteHighlightColor
    @Binding var selectedColorId: String
    
    var body: some View {
        
        Button(action: {
            selectedColorId = noteColor.id ?? "d6eeb4b3-d8ac-4fc2-a58d-85a5475d6cd6"
        }, label: {
            Color(hex: noteColor.colorHex ?? "#FFFFFF")
                .clipShape(Circle())
                .shadow(radius: 3)
                .overlay {
                    if selectedColorId == noteColor.id {
                        Circle()
                            .stroke(ColorManager.textColor,lineWidth: 0.8)
                    }
                }
        })
        
        
    }
}

struct NoteColorSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        NoteColorSelector(colorList: [], selectedColorId: .constant("d6eeb4b3-d8ac-4fc2-a58d-85a5475d6cd6")) {}
    }
}

//#Preview {
//    NavigationStack {
//        NoteColorSelector(colorList: ["#FFFFFF","#FF0000","#00FF00","#008000","#0000FF","#800080"], selectedColor: .constant("#FFFFFF"))
//            .navigationDestination(for: AddNoteDestinations.self) { value in
//                Text("Color")
//            }
//    }
//}

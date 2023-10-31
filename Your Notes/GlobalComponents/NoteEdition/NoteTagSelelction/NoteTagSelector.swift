//
//  NoteTagSelector.swift
//  Your Notes
//
//  Created by Franco Marquez on 18/10/23.
//

import SwiftUI

struct NoteTagSelector: View {
    
    @State private var showAddTagForm: Bool = false
    @State private var showAddTagButton: Bool = false
    @State private var newTagText = ""
    @Binding var actualTag : UUID?
    @Binding var tags : [NoteTag]
    var doWhenSaveNewTag: (String) -> ()
    
    var body: some View {
        
        VStack (spacing: 10){
            
            if showAddTagForm {
                HStack {
                    NoteFormTextField(noteText: $newTagText,
                                      showBackground: false,
                                      placeholderText: "Tag...")
                    
                    if showAddTagButton{
                        Button(action: {
                            doWhenSaveNewTag(newTagText)
                            newTagText = ""
                            withAnimation (.linear){
                                showAddTagForm = false
                            }
                        }, label: {
                            Image(systemName: GlobalValues.NoFilledIcons.plusSquare)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25, alignment: .center)
                                .padding(.horizontal)
                        })
                    }
                }
                .onChange(of: newTagText) { newText in
                    
                    if newText.isEmpty{
                        withAnimation(.linear){
                            showAddTagButton = false
                        }
                    }else {
                        withAnimation(.linear){
                            showAddTagButton = true
                        }
                    }
                    
                }
            }
            
            ScrollView(.horizontal){
                HStack (spacing: 30){
                    Button(action: {
                        
                        withAnimation(.linear){
                            showAddTagForm = true
                        }
                        
                        
                    }, label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 33, height: 33)
                    })
                    
                    
                    HStack {
                        ForEach(tags){ tag in
                            TagFrame(noteTag: tag, actualTag: $actualTag)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        
    }
}

fileprivate struct TagFrame: View {
    
    var noteTag: NoteTag
    @Binding var actualTag: UUID?
    
    var isSelected: Bool {
        guard let tag = actualTag else { return false }
        
        if tag == noteTag.id { return true }
        
        return false
        
    }
    
    var body: some View {
        
        Button(action: {
            
            if actualTag == noteTag.id{
                actualTag = nil
                return
            }
            
            actualTag = noteTag.id
            
        }, label: {
            Text(noteTag.tag ?? "")
                .foregroundColor(isSelected ? ColorManager.primaryColor : Color.gray)
                .padding(.horizontal)
                .padding(.vertical,5)
                .overlay {
                    Capsule()
                        .stroke(isSelected ? ColorManager.primaryColor : Color.gray.opacity(0.5),
                                lineWidth: 2)
                }
        })
        
        
    }
}

//
//#Preview {
//    NoteTagSelector(actualTag: .constant(ClassTag(tag: "home")), tagList: .constant([ClassTag(tag: "home"),ClassTag(tag: "class")]))
//}

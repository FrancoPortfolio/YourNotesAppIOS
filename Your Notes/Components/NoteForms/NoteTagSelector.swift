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
    @Binding var actualTag: ClassTag?
    @Binding var tagList: [ClassTag]
    
    init(actualTag: Binding<ClassTag?>, tagList: Binding<[ClassTag]>) {
        self._actualTag = actualTag
        self._tagList = tagList
    }
    
    var body: some View {
        
        VStack (spacing: 10){
            
            if showAddTagForm {
                HStack {
                    NoteFormTextField(noteText: $newTagText,
                                      showBackground: false,
                                      placeholderText: "Tag...")
                    
                    if showAddTagButton{
                        Button(action: {
                            tagList.append(ClassTag(tag: "#" + newTagText))
                            newTagText = ""
                            withAnimation (.linear){
                                showAddTagForm = false
                            }
                        }, label: {
                            Image(systemName: "plus.square")
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
                        ForEach(tagList){ tagClass in
                            TagFrame(tagClass: tagClass, actualTag: $actualTag)
                        }
                    }
                }
            }
        }
        
    }
}

fileprivate struct TagFrame: View {
    
    var tagClass: ClassTag = ClassTag(tag: "")
    @Binding var actualTag: ClassTag?
    
    var isSelected: Bool {
        guard let tagSelected = actualTag else { return false }
        
        if tagSelected.tag == tagClass.tag { return true }
        
        return false
        
    }
    
    var body: some View {
        
        Button(action: {
            
            actualTag = tagClass
            
        }, label: {
            Text(tagClass.tag)
                .foregroundStyle(ColorManager.textColor)
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


#Preview {
    NoteTagSelector(actualTag: .constant(ClassTag(tag: "home")), tagList: .constant([ClassTag(tag: "home"),ClassTag(tag: "class")]))
}

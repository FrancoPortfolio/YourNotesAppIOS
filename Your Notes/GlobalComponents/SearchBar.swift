//
//  SearchBar.swift
//  Your Notes
//
//  Created by Franco Marquez on 16/10/23.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String
    
    @State private var isEditing = false
    @State private var runInitialAnimation = false
    @Binding var show : Bool
    
    var body: some View {
        
        if show {
            
            GeometryReader(content: { geometry in
                 
                HStack {
                    TextField("Search ...", text: $searchText)
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                        .frame(maxWidth: isEditing ? geometry.size.width * 0.8 : .infinity)
                        .onTapGesture {
                            withAnimation (.linear(duration: 0.1)) {
                                self.isEditing = true
                            }
                        }
                    
                    if isEditing {
                        Button(action: {
                            withAnimation (.linear){
                                self.isEditing = false
                                self.show = false
                            }
                            
                            self.searchText = ""
                        }) {
                            Text("Cancel")
                                .padding(10)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.6)
                        }
                        .frame(maxWidth: geometry.size.width * 0.2, alignment: .center)
                        .transition(.move(edge: .trailing))
                    }
                }
                .frame(maxHeight: 50)
                .overlay(
                    HStack {
                        Image(systemName: GlobalValues.NoFilledIcons.glass)
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .offset(x: geometry.size.width * 0.04)
                        
                        if isEditing {
                            Button(action: {
                                self.searchText = ""
                            }) {
                                Image(systemName: GlobalValues.FilledIcons.Xbutton)
                                    .foregroundColor(.gray)
                            }
                            .offset(x: geometry.size.width * -0.27)
                        }
                    }
                )
            })
            
        }
        
    }
}
//
//struct SearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBar(searchText: .constant(""))
//    }
//}

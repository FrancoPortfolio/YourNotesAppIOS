//
//  Header.swift
//  Your Notes
//
//  Created by Franco Marquez on 31/10/23.
//

import SwiftUI

struct Header: View {
    
    @State private var showSearchBar = false
    var title: String
    
    @Binding var searchText : String
    @Binding var showOnlyFavorites : Bool
    @Binding var noteSorting : NotesSorting
    
    private var starIconName: String {
        if showOnlyFavorites {
            return GlobalValues.FilledIcons.favoriteStar
        }
        return GlobalValues.NoFilledIcons.favoriteStar
    }
    
    var body: some View {
            Group{
                HStack{
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    HStack(spacing: 15) {
                        
                        Button{
                            withAnimation (.spring(response: 0.3, dampingFraction: 0.9, blendDuration: 2)) {
                                showSearchBar.toggle()
                            }
                        } label: {
                            Image(systemName: GlobalValues.NoFilledIcons.glass)
                                .font(.title2)
                        }
                        
                        Button {
                            showOnlyFavorites.toggle()
                        } label: {
                            Image(systemName: starIconName)
                                .font(.title2)
                        }
                        
                        Menu {
                                Picker("Sort by", selection: $noteSorting) {
                                    ForEach(NotesSorting.allCases){ sort in
                                        Text(sort.title).tag(sort)
                                    }
                                }.pickerStyle(MenuPickerStyle())
                        } label: {
                            Image(systemName: GlobalValues.NoFilledIcons.listBullet)
                                .font(.title2)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 60)
                
                SearchBar(searchText: $searchText, show: $showSearchBar)
                    .padding(.top, -10)
                    .offset(y: showSearchBar ? 0 : -600)
                    .frame(height: showSearchBar ? 50 : 0)
            }
    }
}

//struct Header_Previews: PreviewProvider {
//    static var previews: some View {
//        Header()
//    }
//}

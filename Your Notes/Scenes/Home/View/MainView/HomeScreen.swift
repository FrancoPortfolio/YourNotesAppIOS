//
//  HomeScreen().swift
//  Your Notes
//
//  Created by Franco Marquez on 16/10/23.
//

import SwiftUI

struct HomeScreen: View {
    
    @State private var searchText: String = ""
    @State private var showSearchBar: Bool = false
    @State private var showOnlyFavorites: Bool = false
    @State private var selectedSorting: NotesSorting = .dateAddedNewer
    @State private var navigationPath: [HomeRoutingDestinations] = []
    
    private var starIconName: String {
        if showOnlyFavorites {
            return "star.fill"
        }
        return "star"
    }
    
    var body: some View {
        
        NavigationStack(path: $navigationPath) {
            VStack{
                
                //Header
                Group{
                    Group {
                        HStack {
                            Text("My Notes")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.leading,20)
                            
                            Spacer()
                            
                            HStack (spacing: 15){
                                Button {
                                    withAnimation (.spring(response: 0.3, dampingFraction: 0.9, blendDuration: 2)) {
                                        showSearchBar.toggle()
                                    }
                                } label: {
                                    Image(systemName: "magnifyingglass")
                                        .font(.title2)
                                }
                                
                                Button {
                                    showOnlyFavorites.toggle()
                                } label: {
                                    Image(systemName: starIconName)
                                        .font(.title2)
                                }
                                
                                Menu {
                                    Picker("Sort", selection: $selectedSorting) {
                                        ForEach(NotesSorting.allCases){
                                            Text($0.title).tag($0)
                                        }
                                    }
                                } label: {
                                    Image(systemName: "list.bullet")
                                        .font(.title2)
                                }
                            }
                            .padding(.trailing, 20)
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: 60)
                    }
                    
                    SearchBar(searchText: $searchText)
                        .padding(.top, -10)
                        .offset(y: showSearchBar ? 0 : -600)
                }
                
                //Body
                Group {
                    HomeScreenBody()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background {
                ColorManager.backgroundColor.opacity(0.8)
                    .ignoresSafeArea()
            }
            .navigationTitle("My Notes")
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: HomeRoutingDestinations.self) { destination in
                
                switch destination {
                case .newNote: NewNoteScreen()
                case .editNote: Text("Edit")
                }
                
            }
        }
        
        
    }
}

#Preview {
    HomeScreen()
}

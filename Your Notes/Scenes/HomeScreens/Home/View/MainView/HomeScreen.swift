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
    @State private var navigationPath: NavigationPath = NavigationPath()
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()
    
    private var starIconName: String {
        if showOnlyFavorites {
            return GlobalValues.FilledIcons.favoriteStar
        }
        return GlobalValues.NoFilledIcons.favoriteStar
    }
    
    var body: some View {
        
        NavigationStack(path: $navigationPath) {
            VStack{
                
                //Header
                Group{
                    Group {
                        HStack {
                            Text(GlobalValues.Strings.homeScreenTitle)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            HStack (spacing: 15){
                                Button {
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
                                    Picker("Sort", selection: $selectedSorting) {
                                        ForEach(NotesSorting.allCases){
                                            Text($0.title).tag($0)
                                        }
                                    }
                                } label: {
                                    Image(systemName: GlobalValues.NoFilledIcons.listBullet)
                                        .font(.title2)
                                }
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: 60)
                    }
                    
                    SearchBar(searchText: $searchText)
                        .padding(.top, -10)
                        .offset(y: showSearchBar ? 0 : -600)
                        .frame(height: showSearchBar ? 50 : 0)
                        
                }
                
                //Body
                HomeScreenBody(notes: viewModel.notes)
                    .onAppear{
                        viewModel.getNoteData()
                    }
                
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background {
                ColorManager.backgroundColor.opacity(0.8)
                    .ignoresSafeArea()
            }
            .navigationTitle("My Notes")
            .toolbar(.hidden, for: .navigationBar)
            //            Navigation Views Destinations
            .navigationDestination(for: HomeRoutingDestinations.self) { destination in
                
                switch destination {
                case .newNote: NewNoteScreen()
                case .editNote: Text("Edit")
                }
                
            }
            
        }
        
        
    }
}
//struct HomeScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        Text("XD")
//        //HomeScreen()
//    }
//}

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
    
    var body: some View {
        
        NavigationStack(path: $navigationPath) {
            VStack{
                
                //Header
                Header(title: GlobalValues.Strings.homeScreenTitle,
                       searchText: $searchText,
                       showOnlyFavorites: $showOnlyFavorites, noteSorting: $selectedSorting)
                .onChange(of: showOnlyFavorites) { newValue in
                    if newValue{
                        viewModel.getFavoritesNoteData()
                    }else{
                        viewModel.sortNotes(sortCriteria: selectedSorting)
                    }
                }
                
                //Body
                NoteListBodyGrid(firstColumnsNotes: viewModel.firstColumnArray,
                               secondColumnsNotes: viewModel.secondColumnArray)
                    .onAppear{
                        viewModel.sortNotes(sortCriteria: selectedSorting)
                    }
                    .onChange(of: self.searchText) { newValue in
                        if newValue == "" {
                            viewModel.getAllNoteData()
                            return
                        }
                        viewModel.searchByTextTag(text: newValue)
                    }
                
            }
            .onChange(of: self.selectedSorting, perform: { newValue in
                viewModel.sortNotes(sortCriteria: newValue)
            })
            .modifier(MainStyle(navigationTitle: GlobalValues.Strings.homeScreenTitle))
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

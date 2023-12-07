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
    @State private var navigationPath: NavigationPath = NavigationPath()
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        
        NavigationStack(path: $navigationPath) {
            VStack{
                
                //Header
                Header(title: GlobalValues.Strings.ScreenTitles.homeScreenTitle,
                       searchText: $searchText,
                       showOnlyFavorites: $viewModel.showFavorites,
                       noteSorting: $viewModel.sortBy)
                
                //Body
                NoteListBodyGrid(firstColumnsNotes: viewModel.firstColumnArray,
                                 secondColumnsNotes: viewModel.secondColumnArray,
                                 navPath: self.$navigationPath,
                                 viewModel: self.viewModel)
                    .onAppear{
                        viewModel.getAllNoteData()
                    }
                    .onChange(of: self.searchText) { newValue in
                        if newValue == "" {
                            viewModel.getAllNoteData()
                            return
                        }
                        viewModel.searchByTextTag(text: newValue)
                    }
                
            }
            .onChange(of: self.viewModel.sortBy, perform: { newValue in
                viewModel.getAllNoteData()
            })
            .onChange(of: viewModel.showFavorites, perform: { newValue in
                viewModel.getAllNoteData()
            })
            .modifier(MainStyle(navigationTitle: GlobalValues.Strings.ScreenTitles.homeScreenTitle))
            //            Navigation Views Destinations
            .navigationDestination(for: HomeRoutingDestinations.self) { destination in
                switch destination {
                case .newNote: NewNoteScreen()
                case .editNote: Text("Edit")
                case .expandNote(let noteId): ExtendedNoteScreen(noteId: noteId)
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

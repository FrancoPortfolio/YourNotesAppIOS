//
//  ContentView.swift
//  Your Notes
//
//  Created by Franco Marquez on 16/10/23.
//

import SwiftUI

struct MainScreen: View {
    
    @State private var selectedScreen: MainScreenViews = .homeScreen
    
    var body: some View {
        TabView(selection: $selectedScreen){
            Group {
                HomeScreen()
                    .tag(MainScreenViews.homeScreen)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                
                Text("Unsorted")
                    .tag(MainScreenViews.unclassified)
                    .tabItem {
                        Label("Unsorted Notes", systemImage: "note")
                    }
                
                Text("Sorted")
                    .tag(MainScreenViews.classified)
                    .tabItem {
                        Label("Sorted Notes", systemImage: "list.clipboard.fill")
                    }
            }
            .toolbarBackground(ColorManager.backgroundColor, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}



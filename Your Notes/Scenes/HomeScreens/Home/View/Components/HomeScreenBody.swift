//
//  HomeScreenBody.swift
//  Your Notes
//
//  Created by Franco Marquez on 16/10/23.
//

import SwiftUI

struct HomeScreenBody: View {
    
    private var addNoteButton: some View{
        
        
        NavigationLink(value: HomeRoutingDestinations.newNote) {
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .foregroundStyle(ColorManager.primaryColor)
                .padding()
                .background{
                    ColorManager.secondaryColor
                }
                .clipShape(Circle())
                .padding()
        }
        

    }
    
    var body: some View {
        ZStack{
            //Notes Grid
            
            //Bottom FAB
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    addNoteButton
                }
            }
        }
    }
}

struct HomeScreenBody_Previews: PreviewProvider{
    
    static var previews: some View{
        HomeScreenBody()
    }
    
}

//#Preview {
//    HomeScreenBody()
//}

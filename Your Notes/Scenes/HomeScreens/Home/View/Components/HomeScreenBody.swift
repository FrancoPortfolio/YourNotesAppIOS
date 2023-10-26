//
//  HomeScreenBody.swift
//  Your Notes
//
//  Created by Franco Marquez on 16/10/23.
//

import SwiftUI

struct HomeScreenBody: View {
    
    var notes: [Note] = []
    
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
            GeometryReader{ geo in
                
                ScrollView{
                    
                    HStack{
                        //First Column
                        VStack{
                            ForEach(notes){note in
                                NoteShortView(note: note)
                                    .frame(minWidth: 0,maxWidth: geo.size.width * 0.5)
                                    .padding(.vertical, 5)
                            }
                        }
                        //Second column
                        VStack{
                            ForEach(notes){note in
                                NoteShortView(note: note)
                                    .frame(minWidth: 0,maxWidth: geo.size.width * 0.5)
                                    .padding(.vertical, 5)
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            //Bottom FAB
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    addNoteButton
                    Spacer()
                }
            }
        }
    }
}

//struct HomeScreenBody_Previews: PreviewProvider{
//
//    static var previews: some View{
//        HomeScreenBody()
//    }
//
//}

//#Preview {
//    HomeScreenBody()
//}

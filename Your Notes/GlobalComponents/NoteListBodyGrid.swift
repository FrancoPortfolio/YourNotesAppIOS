//
//  HomeScreenBody.swift
//  Your Notes
//
//  Created by Franco Marquez on 16/10/23.
//

import SwiftUI

struct NoteListBodyGrid: View {
    
    @StateObject private var audioManager = AudioRecordingPlayingManager()
    
    var firstColumnsNotes: [Note] = []
    var secondColumnsNotes: [Note] = []
    
    private var addNoteButton: some View{
        NavigationLink(value: HomeRoutingDestinations.newNote) {
            Image(systemName: GlobalValues.NoFilledIcons.plus)
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
                HStack{
                    //First Column
                    ScrollView(.vertical){
                        VStack{
                            ForEach(firstColumnsNotes){note in
                                NoteShortView(audioManager: audioManager, note: note){
                                    Text("xd")
                                }
                                    .frame(minWidth: 0,maxWidth: geo.size.width * 0.5)
                                    .padding(.vertical, 5)
                            }
                        }.padding(.horizontal,3)
                    }
                    .scrollIndicators(.hidden)
                    //Second column
                    ScrollView(.vertical){
                        VStack{
                            ForEach(secondColumnsNotes){note in
                                NoteShortView(audioManager: audioManager, note: note){
                                    Text("Xd")
                                        .presentationDetents([PresentationDetent.fraction(0.4)])
                                }
                                    .frame(minWidth: 0,maxWidth: geo.size.width * 0.5)
                                    .padding(.vertical, 5)
                            }
                        }.padding(.horizontal,3)
                            .frame(maxWidth: geo.size.width * 0.5)
                    }.scrollIndicators(.hidden)
                }
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

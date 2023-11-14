//
//  NoteAddSectionButton.swift
//  Your Notes
//
//  Created by Franco Marquez on 17/10/23.
//

import SwiftUI

struct NoteAddSectionButton: View {
    
    var iconName: String = "camera.fill"
    var size : CGFloat = 30
    var doOnButtonPressed : () -> ()
    
    var body: some View {
        
        ZStack{
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.gray.opacity(0.2))
            
            Button(action: {
                doOnButtonPressed()
            }, label: {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .padding(25)
            })
            
            VStack{
                HStack{
                    Image(systemName: GlobalValues.NoFilledIcons.plus).padding(5)
                        .foregroundStyle(ColorManager.primaryColor)
                    Spacer()
                }
                Spacer()
            }
        }.frame(width: size,height: size)
    }
}

//struct NoteAddSectionButton_Previews: PreviewProvider {
//    static var previews: some View {
//        NoteAddSectionButton() {}
//    }
//}

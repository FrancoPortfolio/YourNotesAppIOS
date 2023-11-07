//
//  IconPlayerVoicenote.swift
//  Your Notes
//
//  Created by Franco Marquez on 7/11/23.
//

import SwiftUI

struct IconPlayerVoicenote: View {
    
    var isPaused: Bool
    var isThisPlaying: Bool
    
    private var iconName: String{
        if isThisPlaying{
            if isPaused{
                return GlobalValues.FilledIcons.Media.play
            }
            return GlobalValues.FilledIcons.Media.pause
        }
        return GlobalValues.FilledIcons.Media.play
    }
    
    var body: some View {
        Image(systemName: iconName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30)
    }
}

//struct IconPlayerVoicenote_Previews: PreviewProvider {
//    static var previews: some View {
//        IconPlayerVoicenote()
//    }
//}

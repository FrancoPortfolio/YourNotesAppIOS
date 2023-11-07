//
//  ProgressBarVoicenote.swift
//  Your Notes
//
//  Created by Franco Marquez on 7/11/23.
//

import SwiftUI

struct ProgressBarVoicenote: View {
    
    var isPlaying: Bool
    var progress: CGFloat
    
    var body: some View {
        ZStack (alignment: .center){
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color.gray)
            
            if isPlaying{
                GeometryReader{ geo in
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(ColorManager.primaryColor)
                        .padding(.trailing, geo.size.width * (1 - progress))
                        .animation(.linear, value: progress)
                }
            }
        }
        .frame(height: 10)
    }
}

//struct ProgressBarVoicenote_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgressBarVoicenote()
//    }
//}

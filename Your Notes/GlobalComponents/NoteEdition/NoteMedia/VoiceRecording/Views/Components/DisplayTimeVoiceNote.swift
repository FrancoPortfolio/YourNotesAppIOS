//
//  Timer.swift
//  Your Notes
//
//  Created by Franco Marquez on 7/11/23.
//

import SwiftUI
import AVFoundation

struct DisplayTimeVoiceNote: View {
    
    var audioInSeconds : CGFloat
    
    private var timeAudioMinutes: Int{
        return Int(self.audioInSeconds / 60)
    }
    
    private var timeAudioSeconds: Int{
        return Int(round(self.audioInSeconds.truncatingRemainder(dividingBy: 60.0)))
    }
    
    var body: some View {
        Text("\(String(format: "%02d", timeAudioMinutes)):\(String(format: "%02d", timeAudioSeconds))")
            .font(.system(size: 18))
    }
}

//struct Timer_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplayTimeVoiceNote()
//    }
//}

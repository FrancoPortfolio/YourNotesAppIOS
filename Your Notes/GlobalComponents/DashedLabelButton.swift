//
//  DashedLabelButton.swift
//  Your Notes
//
//  Created by Franco Marquez on 30/11/23.
//

import SwiftUI

struct DashedLabelButton: View {
    
    var labelTitle : String
    var systemImageName : String
    var doOnButtonPressed : () -> ()
    
    var body: some View {
        Button {
            doOnButtonPressed()
        } label: {
            Label(labelTitle, systemImage: systemImageName)
                .expandedDashedLabel()
        }
    }
}

//struct DashedLabelButton_Previews: PreviewProvider {
//    static var previews: some View {
//        DashedLabelButton()
//    }
//}

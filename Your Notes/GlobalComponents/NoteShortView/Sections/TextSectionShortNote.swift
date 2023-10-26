//
//  TextSectionShortNote.swift
//  Your Notes
//
//  Created by Franco Marquez on 17/10/23.
//

import SwiftUI

struct TextSectionShortNote: View {
    private var text: String = ""
    
    init(textData: String? = nil) {
    
        guard let text = textData else {
            return
        }
        
        self.text = text
        
    }
    
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 16))
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity)
        }
        
    }
}

//struct TextSectionShortNote_Previews: PreviewProvider {
//    static var previews: some View {
//        TextSectionShortNote()
//    }
//}

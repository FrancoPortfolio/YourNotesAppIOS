//
//  NoteShortIndicators.swift
//  Your Notes
//
//  Created by Franco Marquez on 6/11/23.
//

import SwiftUI

struct NoteShortIndicators: View {
    
    var isFavorite: Bool
    var isTagged: Bool
    var isPinned: Bool
    var contentSections: [contentSections]
    
    var body: some View {
        HStack{
            //Favorite indicator
            if isFavorite {
                Image(systemName: GlobalValues.FilledIcons.favoriteStar)
                    .font(.callout)
            }
            //Other indicators
            if !contentSections.isEmpty{
                HStack{
                    ForEach(contentSections, id: \.self){ contentSection in
                        
                        switch contentSection{
                        case .images: Image(systemName: GlobalValues.FilledIcons.imageIcon)
                        case .subtasks: Image(systemName: GlobalValues.FilledIcons.subtaskIcon)
                        case .voicenotes: Image(systemName: GlobalValues.FilledIcons.micIcon)
                        case .drawing: Image(systemName: GlobalValues.FilledIcons.brushIcon)
                        }
                    }
                }
                .font(.callout)
                .foregroundColor(ColorManager.textColor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal,10)
        .padding(.top,10)
        .foregroundColor(ColorManager.textTitleColor)
    }
}
//
//struct NoteShortIndicators_Previews: PreviewProvider {
//    static var previews: some View {
//        NoteShortIndicators()
//    }
//}

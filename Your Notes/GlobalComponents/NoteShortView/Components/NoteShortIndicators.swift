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
    var contentSections: ([contentSections], Int)
    
    var body: some View {
        HStack{
            //Favorite indicator
            if isFavorite {
                Image(systemName: GlobalValues.FilledIcons.favoriteStar)
                    .font(.callout)
            }
            //Other indicators
            if contentSections.0.count > 2{
                HStack{
                    ForEach(2..<Int(contentSections.0.count)){ index in
                        
                        switch contentSections.0[index]{
                        case .images: Image(systemName: GlobalValues.FilledIcons.imageIcon)
                        case .subtasks: Image(systemName: GlobalValues.FilledIcons.subtaskIcon)
                        case .text: Image(systemName: GlobalValues.FilledIcons.textIcon)
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
        .padding(.vertical, isPinned || isTagged ? 0 : 7)
    }
}
//
//struct NoteShortIndicators_Previews: PreviewProvider {
//    static var previews: some View {
//        NoteShortIndicators()
//    }
//}

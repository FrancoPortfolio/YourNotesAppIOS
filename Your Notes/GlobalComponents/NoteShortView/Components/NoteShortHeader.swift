//
//  NoteShortHeader.swift
//  Your Notes
//
//  Created by Franco Marquez on 6/11/23.
//

import SwiftUI

struct NoteShortHeader: View{
    
    var note: Note
    
    var isPinned : Bool
    
    var isFavorite: Bool
    
    var isTagged: Bool
    
    var body: some View{
        HStack{
            if isTagged{
                HStack{
                    Text("#\(note.tag!.tag!)")
                        .font(.footnote)
                        .foregroundColor(ColorManager.textColor)
                        .opacity(0.8)
                        .padding(.leading, 10)
                    if !isPinned{
                        Spacer()
                    }
                }
            }
            
            if isPinned && isTagged{
                Spacer()
            }
            
            if isPinned{
                HStack{
                    if !isTagged{
                        Spacer()
                    }
                    Image(systemName: GlobalValues.FilledIcons.pinIcon)
                        .font(.footnote)
                        .rotationEffect(Angle(degrees: 45))
                        .foregroundColor(Color.gray.opacity(0.9))
                        .frame(width: 20, alignment: .trailing)
                        .padding([.trailing],5)
                }
                
            }
        }
        .padding(.top, isPinned || isTagged ? 7 : 0)
    }
}

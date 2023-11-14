//
//  Text.swift
//  Your Notes
//
//  Created by Franco Marquez on 24/10/23.
//

import Foundation
import SwiftUI

extension Text{
    func newNoteSubtitle() -> some View{
        self
            .font(.headline)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top)
        
    }
    
    func extendedNoteSubtitle() -> some View{
        self
            .font(.headline)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension Label{
    func expandedDashedLabel() -> some View{
        self.font(Font.subheadline)
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [4]))
            }
    }
}


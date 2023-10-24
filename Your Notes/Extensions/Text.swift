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
}


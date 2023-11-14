//
//  LoadingView.swift
//  Your Notes
//
//  Created by Franco Marquez on 14/11/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack{
            Color.black.opacity(0.2)
            ProgressView()
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

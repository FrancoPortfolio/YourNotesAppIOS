//
//  ImagesSectionShortNote.swift
//  Your Notes
//
//  Created by Franco Marquez on 27/10/23.
//

import SwiftUI

struct ImagesSectionShortNote: View {
    
    @StateObject private var viewModel: ImagesSectionShortNoteViewModel
    private var onlyOneImage: Bool{
        return viewModel.images.count == 1
    }
    
    init(imagesSet: NSSet? = nil){
        self._viewModel = StateObject(wrappedValue: ImagesSectionShortNoteViewModel(imagesDataSet: imagesSet))
    }
    
    var body: some View {
        Group{
            ScrollView(.horizontal){
                if onlyOneImage{
                    ImageView(image: viewModel.images.first!, isComplete: true)
                } else{
                    HStack{
                        ForEach(viewModel.images, id: \.self){ NoteImage in
                            ImageView(image: NoteImage, isComplete: false)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .scrollDisabled(onlyOneImage)
            .cornerRadius(10, corners: [.bottomLeft,.bottomRight])
        }
    }
}

fileprivate struct ImageView: View {
    
    @State var show = true
    var image: NoteImage
    var isComplete: Bool
    
    var body: some View {
        HStack{
            if show{
                Image(uiImage: UIImage(data:image.imageData!)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: isComplete ? 350 : 150, height: 150)
                    .clipped()
            }
        }
        .onAppear{
            show = true
        }
        .onDisappear{
            show = false
        }
    }
}

struct ImagesSectionShortNote_Previews: PreviewProvider {
    static var previews: some View {
        ImagesSectionShortNote()
    }
}

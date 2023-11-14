//
//  ImageEditable.swift
//  Your Notes
//
//  Created by Franco Marquez on 8/11/23.
//

import SwiftUI

struct ImageEditable: View {
    
    var size: CGFloat = 100
    var uiImage: UIImage
    var doWhenEraseButtonPressed : () -> ()
    
    init(uiImage: UIImage, doWhenEraseButtonPressed: @escaping () -> Void) {
        self.uiImage = uiImage
        self.doWhenEraseButtonPressed = doWhenEraseButtonPressed
    }
    
    init(size: CGFloat?, noteImage: NoteImage, doWhenEraseButtonPressed: @escaping () -> Void){
        self.doWhenEraseButtonPressed = doWhenEraseButtonPressed
        if let sizeFinal = size{
            self.size = sizeFinal
        }
        if let imageData = noteImage.imageData, let uiImage = UIImage(data: imageData){
            self.uiImage = uiImage
            return
        }
        self.uiImage = UIImage()
    }
    
    var body: some View {
        Image(uiImage: uiImage)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                Button {
                    doWhenEraseButtonPressed()
                } label: {
                    VStack{
                        HStack{
                            Spacer()
                            Image(systemName: GlobalValues.NoFilledIcons.xButton)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.white)
                                .fontWeight(.thin)
                                .frame(width: 25, height:25)
                                .padding(5)
                        }.frame(maxWidth: .infinity)
                        Spacer()
                    }
                    .frame(maxHeight: .infinity)
                }
                
            }
    }
}

//struct ImageEditable_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageEditable()
//    }
//}

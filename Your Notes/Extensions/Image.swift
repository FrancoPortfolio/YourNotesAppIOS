//
//  Image.swift
//  Your Notes
//
//  Created by Franco Marquez on 27/10/23.
//

import Foundation
import UIKit
import PencilKit
import SwiftUI

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
    
    static func getUIImageFromCanvasData(data: Data, size: CGSize = CGSize(width: 300, height: 450)) -> UIImage{
        let canvas = PKCanvasView()
        var image = UIImage()
        let cgRect = CGRect(origin: CGPoint.zero,size: size)
        do{
            try canvas.drawing = PKDrawing(data: data)
            image = canvas.drawing.image(from: cgRect, scale: 1.0)
        } catch {
            Log.error("Error making image from canvas: \(error)")
        }
        return image
    }
}

extension Image{
    
    func generalIconButton() -> some View{
        self.resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30)
    }
    
    func iconButton(size: CGFloat) -> some View{
        self.resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size)
    }
    
    func drawingOnExtendedNote() -> some View{
        self.resizable()
            .scaledToFill()
            .clipped()
            .frame(width: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(ColorManager.secondaryColor, lineWidth: 3)
            }
    }
    
}

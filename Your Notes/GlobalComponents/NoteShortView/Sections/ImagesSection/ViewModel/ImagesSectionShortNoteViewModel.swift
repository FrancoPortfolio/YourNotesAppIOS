//
//  ImagesSectionViewModel.swift
//  Your Notes
//
//  Created by Franco Marquez on 26/10/23.
//

import Foundation
import UIKit

@MainActor
class ImagesSectionShortNoteViewModel: ObservableObject{
    
    @Published var images = [NoteImage]()
    
    init(imagesDataSet: NSSet?){
        
        guard let imagesSet = imagesDataSet else { return }
        
        self.images = turnSetToImageArray(imageSet: imagesSet)
    }
    
    private func turnArrayNoteImagesToImages(data: [NoteImage]) -> [UIImage]{
        if data.isEmpty { return [] }
        
        var finalArray = [UIImage]()
        
        for noteImage in data {
            if let datum = noteImage.imageData {
                if let image = UIImage(data: datum){
                    finalArray.append(image)
                }
            }
        }
        
        return finalArray
    }
    
    private func turnSetToImageArray(imageSet: NSSet?) -> [NoteImage]{
        guard let noteImagesArray = DataManager.turnSetToArray(set: imageSet, typeToConvert: NoteImage.self) else { return [] }
        return noteImagesArray
//        return turnArrayNoteImagesToImages(data: noteImagesArray)
    }
}

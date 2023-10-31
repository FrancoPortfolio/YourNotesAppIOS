//
//  DrawingSectionShortNote.swift
//  Your Notes
//
//  Created by Franco Marquez on 30/10/23.
//

import Foundation
import UIKit

class DrawingSectionShortNoteViewModel: ObservableObject{
    
    var drawingNote : NoteDrawing?
    var uiImage: UIImage = UIImage()
    
    init(drawingNote: NoteDrawing?) {
        
        self.drawingNote = drawingNote
        
        if let drawingNote{
            if let drawingData = drawingNote.drawingData{
                self.uiImage = UIImage.getUIImageFromCanvasData(data: drawingData)
                return
            }
        }
    }
}

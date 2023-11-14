//
//  DrawingCanvasView.swift
//  Your Notes
//
//  Created by Franco Marquez on 23/10/23.
//

import SwiftUI
import CoreData
import PencilKit

struct DrawingCanvasViewForm: UIViewControllerRepresentable {
    
    @Binding var data: Data
    
    func updateUIViewController(_ uiViewController: DrawingCanvasViewController, context: Context) {
        uiViewController.drawingData = data
    }
    typealias UIViewControllerType = DrawingCanvasViewController
    
    func makeUIViewController(context: Context) -> DrawingCanvasViewController {
        let viewController = DrawingCanvasViewController()
        viewController.drawingData = data
        viewController.drawingChanged = { data in
            
            self.data = data 
            
        }
        return viewController
    }
}

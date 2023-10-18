//
//  GalleryPicker.swift
//  Your Notes
//
//  Created by Franco Marquez on 18/10/23.
//

import SwiftUI
import PhotosUI

struct GalleryPicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    var itemProviders: [NSItemProvider] = []
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 5
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: GalleryPicker
        
        init(_ parent: GalleryPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            //Dismiss picker
            picker.dismiss(animated: true)
            
            if !results.isEmpty {
                parent.itemProviders = []
                parent.images = []
            }
            
            parent.itemProviders = results.map(\.itemProvider)
            loadImage()
        }
        
        private func loadImage() {
            for itemProvider in parent.itemProviders {
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.images.append(image)
                            }
                        } else {
                            print("Could not load image", error?.localizedDescription ?? "")
                        }
                    }
                }
            }
        }
    }
}

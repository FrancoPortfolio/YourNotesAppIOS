//
//  CameraScreen.swift
//  Your Notes
//
//  Created by Franco Marquez on 18/10/23.
//

import SwiftUI

struct CameraScreen: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .camera
    var doWithSelectedImage: (UIImage) -> () = {image in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraScreen>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraScreen>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: CameraScreen

        init(_ parent: CameraScreen) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.doWithSelectedImage(image)
                parent.presentationMode.wrappedValue.dismiss()
                return
            }
            
            Log.error("Something went wrong")
            
        }

    }
}

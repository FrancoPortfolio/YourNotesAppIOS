//
//  NewNoteScreenBodyImages.swift
//  Your Notes
//
//  Created by Franco Marquez on 17/11/23.
//

import SwiftUI

struct NewNoteScreenBodyImages: View {
    
    @StateObject var viewModel: AddNewNoteViewModel
    @State private var presentDialogAddImage = false
    @State private var presentGallery = false
    @State private var presentCamera = false
    
    var body: some View {
        VStack{
            Text("Images")
                .newNoteSubtitle()
            
            ScrollView(.horizontal){
                LazyHStack{
                    if !viewModel.imagesToShow.isEmpty{
                        ForEach(viewModel.imagesToShow, id: \.self){ image in
                            ImageEditable(uiImage: image) {
                                viewModel.eraseImage(image: image)
                            }
                        }
                    }
                    
                    NoteAddSectionButton (iconName: GlobalValues.FilledIcons.imageIcon, size: 100){
                        self.presentDialogAddImage.toggle()
                    }
                }
            }
            .confirmationDialog("From where you want to add an image?", isPresented: self.$presentDialogAddImage) {
                Button("Camera", role: .none) {
                    self.openCamera()
                }
                Button("Gallery", role: .none) {
                    self.openGallery()
                }
            }
            .sheet(isPresented: $presentGallery) {
                GalleryPicker(images: self.$viewModel.imagesToShow,
                              maxlimitOfImages: Int(4 - viewModel.imagesToShow.count))
            }
            .sheet(isPresented: self.$presentCamera) {
                CameraScreen(){ image in
                    self.viewModel.imagesToShow.append(image)
                }
            }
        }
    }
}

extension NewNoteScreenBodyImages{
    private func openCamera(){
        PermissionsManager.shared.askPermisionCamera {
            self.presentCamera.toggle()
        } doWhenDenied: {
            Log.warning("No camera allowed")
        }
    }
    
    private func openGallery(){
        self.presentGallery.toggle()
    }
}

//struct NewNoteScreenBodyImages_Previews: PreviewProvider {
//    static var previews: some View {
//        NewNoteScreenBodyImages()
//    }
//}

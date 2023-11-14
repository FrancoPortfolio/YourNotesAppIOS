//
//  ImagesSectionExtendedNote.swift
//  Your Notes
//
//  Created by Franco Marquez on 13/11/23.
//

import SwiftUI

struct ImagesSectionExtendedNote: View{
    @State private var presentConfirmationCamera: Bool = false
    @State private var presentAlertNumberImages: Bool = false
    @State private var showCameraSheet: Bool = false
    @State private var showGallerySheet: Bool = false
    @State private var temporalImages: [UIImage] = []
    var screenMode : ScreenMode
    @Binding var images : [NoteImage]
    var doWhenImageErased : (NoteImage) -> ()
    
    var body: some View{
        
        VStack{
            if self.screenMode == .edit || (!images.isEmpty){
                Text(GlobalValues.Strings.Subtitles.images)
                    .extendedNoteSubtitle()
                    .padding(.top)
            }
            
            if self.screenMode == .display && !images.isEmpty{
                TabView{
                    ForEach(images) { noteImage in
                        if let data = noteImage.imageData, let image = UIImage(data: data){
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .clipped()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .cornerRadius(10)
                .tabViewStyle(.page(indexDisplayMode: .automatic))
                .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            }else{
                if self.screenMode == .edit{
                    ScrollView(.horizontal){
                        LazyHStack(alignment: .center){
                            ForEach(images){ image in
                                ImageEditable(size: 100, noteImage: image) {
                                    doWhenImageErased(image)
                                }
                            }
                            NoteAddSectionButton(iconName: GlobalValues.FilledIcons.imageIcon, size: 100) {
                                onAddButtonPressed()
                            }
                        }
                    }.scrollIndicators(.hidden)
                        .confirmationDialog("From where you want to add an image?", isPresented: self.$presentConfirmationCamera) {
                            Button("Camera", role: .none) {
                                openCamera()
                            }
                            Button("Gallery", role: .none) {
                                openGallery()
                            }
                        }
                        .sheet(isPresented: self.$showCameraSheet) {
                            CameraScreen(){ image in
                                self.addImagesToNoteImageArray(images: [image])
                            }
                        }
                        .sheet(isPresented: self.$showGallerySheet) {
                            GalleryPicker(images: self.$temporalImages, maxlimitOfImages: Int(4 - images.count))
                                .onDisappear{
                                    if self.temporalImages.isEmpty{
                                        return
                                    }
                                    
                                    self.addImagesToNoteImageArray(images: self.temporalImages)
                                    self.temporalImages = []
                                }
                        }
                        .alert("Number of images", isPresented: self.$presentAlertNumberImages) {
                            Button("Return", role: .cancel) {}
                        } message: {
                            Text("The images on the note exceeds the max allowed (4)")
                        }
                }

            }
        }
    }
    
    private func onAddButtonPressed(){
        
        if !checkIfShouldAddImages(){
            self.presentAlertNumberImages.toggle()
            return
        }
        
        presentConfirmationCamera.toggle()
    }
    
    private func checkIfShouldAddImages() -> Bool{
        if self.images.count >= 4{
            Log.warning("4 or more images are selected")
            return false
        }
        return true
    }
    
    private func openCamera(){
        PermissionsManager.shared.askPermisionCamera {
            self.showCameraSheet.toggle()
        } doWhenDenied: {
            Log.error("Access to camera denied")
        }
    }
    
    private func openGallery(){
        self.showGallerySheet.toggle()
    }
    
    private func addImagesToNoteImageArray(images: [UIImage]){
        for image in images{
            if let imgData = image.jpegData(compressionQuality: 0.125){
                
                let noteImgEntity = NoteImage(context: DataManager.standard.container.viewContext)
                
                noteImgEntity.id = UUID()
                noteImgEntity.imageData = imgData
                
                self.images.append(noteImgEntity)
            }
        }
    }
}

//struct ImagesSection_Previews: PreviewProvider {
//    static var previews: some View {
//        ImagesSection()
//    }
//}

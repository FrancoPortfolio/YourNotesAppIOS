//
//  TopSectionEditButtons.swift
//  Your Notes
//
//  Created by Franco Marquez on 31/10/23.
//

import SwiftUI

struct TopSectionNewNoteScreenEditButtons: View {
    
    @Binding var presentGalleryMedia : Bool
    @Binding var presentCameraMedia : Bool
    @Binding var presentMicMedia : Bool
    @Binding var presentDrawingMedia : Bool
    @State private var showNoCameraPermissionAlert = false
    @State private var showNoMicPermissionAlert = false
    
    var body: some View {
        HStack{
            NoteAddSectionButton (iconName: GlobalValues.FilledIcons.imageIcon){presentGalleryMedia.toggle()}
            Spacer()
            NoteAddSectionButton (iconName: GlobalValues.FilledIcons.cameraIcon){
                PermissionsManager.shared.askPermisionCamera {
                    presentCameraMedia.toggle()
                }doWhenDenied: {
                    showNoCameraPermissionAlert.toggle()
                }
            }
            Spacer()
            NoteAddSectionButton (iconName: GlobalValues.FilledIcons.micIcon){
                PermissionsManager.shared.askPermisionMic(doWhenAuthorized: {
                    presentMicMedia.toggle()
                }) {
                    showNoMicPermissionAlert.toggle()
                }
            }
            Spacer()
            NoteAddSectionButton (iconName: GlobalValues.FilledIcons.brushIcon){presentDrawingMedia.toggle()}
        }
        .alert(GlobalValues.Strings.cameraDeniedMessage, isPresented: self.$showNoCameraPermissionAlert) {
            Button("Ok", role: .cancel, action: {})
        }
        .alert(GlobalValues.Strings.micDeniedMessage, isPresented: self.$showNoMicPermissionAlert) {
            Button("Ok", role: .cancel, action: {})
        }
    }
}

//struct TopSectionEditButtons_Previews: PreviewProvider {
//    static var previews: some View {
//        TopSectionNewNoteScreenEditButtons()
//    }
//}

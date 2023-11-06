//
//  PermissionsManagaer.swift
//  Your Notes
//
//  Created by Franco Marquez on 3/11/23.
//

import Foundation
import AVFoundation

class PermissionsManager{
    
    var cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
    var micStatus = AVCaptureDevice.authorizationStatus(for: .audio)
    
    static var shared = PermissionsManager()
    
    func askPermisionCamera(doWhenAuthorized: @escaping () -> () = {}, doWhenDenied: @escaping () -> () = {}){
        updateAllStatus()
        Log.info("Camera permission status = \(cameraStatus)")
        doWithPermission(status: cameraStatus, for: .video) {
            doWhenAuthorized()
        } doWhenDenied: {
            doWhenDenied()
        }
    }
    
    func askPermisionMic(doWhenAuthorized: @escaping () -> () = {}, doWhenDenied: @escaping () -> () = {}){
        updateAllStatus()
        Log.info("Mic permission status = \(cameraStatus)")
        doWithPermission(status: micStatus, for: .audio) {
            doWhenAuthorized()
        } doWhenDenied: {
            doWhenDenied()
        }
    }
    
    private func doWithPermission(status: AVAuthorizationStatus,for mediaType: AVMediaType,doWhenAuthorized: @escaping () -> (), doWhenDenied: @escaping () -> ()){
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: mediaType) { result in
                if result{
                    doWhenAuthorized()
                    return
                }
                doWhenDenied()
                return
            }
        case .restricted:
            Log.info("Permission restricted")
            break
        case .denied:
            doWhenDenied()
            break
        case .authorized:
            doWhenAuthorized()
            break
        @unknown default:
            break
        }
    }
    
    private func updateStatus(for mediaType: AVMediaType){
        
        switch mediaType{
        case .audio:
            self.cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        case .video:
            self.micStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        default:
            return
        }
    }
    
    private func updateAllStatus(){
        self.cameraStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        self.micStatus = AVCaptureDevice.authorizationStatus(for: .video)
    }
}

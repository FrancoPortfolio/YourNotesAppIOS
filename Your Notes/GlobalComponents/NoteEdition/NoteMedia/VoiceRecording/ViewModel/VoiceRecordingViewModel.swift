//
//  VoiceRecordingViewModel.swift
//  Your Notes
//
//  Created by Franco Marquez on 30/10/23.
//

import Foundation
import SwiftUI
import Combine

class VoiceRecordingViewModel: ObservableObject{
    private var fileHandler = FileManagerHandler()
    var actualRecordingFileName = ""
    
    func createBaseFolder(noteId: String){
        fileHandler.createFolderInDocumentDirectory(folderName: "\(GlobalValues.Strings.baseFolderVoicenotes)/\(noteId)")
    }
    
    func getBasePath(noteId: String) -> URL?{
        let documentFolder = fileHandler.findDocumentDirectory()
        var url = documentFolder.appendingPathComponent(GlobalValues.Strings.baseFolderVoicenotes)
        url = url.appendingPathComponent(noteId)
        return url
    }
    
    func eraseLastRecording(noteId: String){
        if let basePath = getBasePath(noteId: noteId){
            let urlToErase = basePath.appendingPathComponent(actualRecordingFileName)
            fileHandler.eraseFileAtURL(url: urlToErase)
        }
    }
    
    func setActualRecordingFileName(fileName: String){
        self.actualRecordingFileName = fileName
    }
    
    func getRecordingURL(noteId: String, fileName: String) -> URL?{
        guard let basePath = getBasePath(noteId: noteId) else { return nil }
        let path = basePath.appendingPathComponent(fileName)
        return path
    }
    
    func prepareForRecording(noteId: String) -> URL?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = GlobalValues.Strings.dayFormat
        let fileName = "YN-\(dateFormatter.string(from: Date())).m4a"
        self.setActualRecordingFileName(fileName: fileName)
        guard let url = getRecordingURL(noteId: noteId, fileName: fileName) else{
            return nil
        }
        return url
    }
    
    func resetRecording() -> String{
        let lastRecording = self.actualRecordingFileName
        self.actualRecordingFileName = ""
        return lastRecording
    }
}

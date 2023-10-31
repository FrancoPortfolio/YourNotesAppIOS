//
//  FileAdministrator.swift
//  Your Notes
//
//  Created by Franco Marquez on 30/10/23.
//

import Foundation

class FileManagerHandler{
    
    private var fileManager = FileManager.default
    
    func checkFolderExists(path: URL) -> Bool{
        do{
            let resourceValues = try path.resourceValues(forKeys: [.isDirectoryKey])
            if let isDirectory = resourceValues.isDirectory {
                if isDirectory {
                    return true
                }
                return false
            } else {
                return false
            }
        } catch {
            Log.error("An error ocurred\(error.localizedDescription)")
            return false
        }
    }
    
    func checkFolderExists(urlString: String) -> Bool{
        guard let url = URL(string: urlString) else { return false }
        
        return checkFolderExists(path: url)
    }
    
    func createFolder(path: URL, withIntermediateFolders: Bool = true){
        do{
            Log.info("Trying to create folder")
            try fileManager.createDirectory(at: path, withIntermediateDirectories: withIntermediateFolders)
            Log.info("Folder created")
        } catch {
            Log.error("An error ocurred: \(error)")
            return
        }
    }
    
    func findDocumentDirectory() -> URL{
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func createFolderInDocumentDirectory(folderName: String){
        let documentDirectory = findDocumentDirectory()
        
        let urlToCreate = documentDirectory.appendingPathComponent(folderName)
        
        if checkFolderExists(path: urlToCreate){
            Log.info("Path: \(urlToCreate) already exists")
            return
        }
        do{
            Log.info("Trying to create folder")
            try fileManager.createDirectory(at: urlToCreate, withIntermediateDirectories: true)
            Log.info("Folder created")
        } catch {
            Log.error("An error ocurred: \(error)")
            return
        }
    }
    
    func eraseFileAtURL(urlString: String){
        if let path = URL(string: urlString){
            do {
                try fileManager.removeItem(at: path)
                Log.info("File erased")
            } catch  {
                Log.error("Error deleting file at \(path) : \(error)")
            }
        }
    }
    
    func eraseFileAtURL(url: URL){
        do {
            try fileManager.removeItem(at: url)
            Log.info("File erased")
        } catch  {
            Log.error("Error deleting file at \(url) : \(error)")
        }
    }
}

extension FileManagerHandler{
    static func getVoicenoteFolder(noteId: String? = nil) -> URL{
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let url = documentDirectory.appendingPathComponent(GlobalValues.Strings.baseFolderVoicenotes)
        
        if let noteId = noteId {
            let finalUrl = url.appendingPathComponent(noteId)
            return finalUrl
        }
        
        return url
        
    }
}


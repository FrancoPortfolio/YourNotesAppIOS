//
//  FileAdministrator.swift
//  Your Notes
//
//  Created by Franco Marquez on 30/10/23.
//

import Foundation

class FileAdministrator{
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
}

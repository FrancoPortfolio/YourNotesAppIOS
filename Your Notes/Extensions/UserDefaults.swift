//
//  UserDefaults.swift
//  Your Notes
//
//  Created by Franco Marquez on 24/10/23.
//

import Foundation

extension UserDefaults{
    func saveDidLoadBefore(){
        UserDefaults.standard.set(true, forKey: "firstLoad")
    }
    
    func returnDidLoadBefore() -> Bool{
        return UserDefaults.standard.bool(forKey: "firstLoad")
    }
}

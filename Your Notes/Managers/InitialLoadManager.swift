//
//  InitalLoadManager.swift
//  Your Notes
//
//  Created by Franco Marquez on 24/10/23.
//

import SwiftUI
import CoreData

class InitialLoadManager{
    
    private struct responseData: Codable{
        let colors: [initialColor]
    }
    
    private struct initialColor: Codable{
        let id: String
        let colorHex: String
    }
    
    static func initialColorsSave(){
        let didLoadBefore = UserDefaults.standard.returnDidLoadBefore()
        
        if !didLoadBefore{
            Log.info("Loading initial data")
            if let path = Bundle.main.path(forResource: "Color", ofType: "json") {
                Log.info("Json found")
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let decoder = JSONDecoder()
                    let colors = try decoder.decode(responseData.self, from: data)
                    for color in colors.colors{
                        let newEntity = NoteHighlightColor(context: DataManager.standard.container.viewContext)
                        newEntity.id = color.id
                        newEntity.colorHex = color.colorHex
                        
                        do {
                            Log.info("Saving colors on core data")
                            try DataManager.standard.container.viewContext.save()
                            UserDefaults.standard.saveDidLoadBefore()
                        } catch  {
                            Log.error("Error saving tag: \(error)")
                        }
                    }
                    
                } catch {
                    Log.error("\(error.localizedDescription)")
                }
            }
        }
    }
}

//
//  AddNoteViewModel.swift
//  Your Notes
//
//  Created by Franco Marquez on 18/10/23.
//

import Foundation
import UIKit

@MainActor
class AddNewNoteViewModel: ObservableObject{
    
    @Published var noteText: String = ""
    @Published var imagesToShow: [UIImage] = []
    @Published var subtasks: [Subtask] = []
    @Published var noteClass: ClassTag? = nil
    @Published var selectedColorHex: String = "#FFFFFF"
    @Published var tempSubtaskText: String = ""
    @Published var tagClasses: [ClassTag] = []
    
    func getColorsFromDatabase(){
        
    }
    
    func getClassesTagFromDatabase(){
        
    }
}

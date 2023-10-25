//
//  AddNoteViewModel.swift
//  Your Notes
//
//  Created by Franco Marquez on 18/10/23.
//

import Foundation
import CoreData
import UIKit

@MainActor
class AddNewNoteViewModel: ObservableObject{
    
    //Core Data relation variables
    @Published var noteId: String = UUID().uuidString
    @Published var noteTagId: UUID? = nil
    @Published var noteText: String = ""
    @Published var selectedColorId: String = "d6eeb4b3-d8ac-4fc2-a58d-85a5475d6cd6"
    
    //Show on view variables
    @Published var imagesToShow: [UIImage] = []
    
    //Temporay variables
    @Published var subtasks: [Subtask] = []
    @Published var tempSubtaskText: String = ""
    @Published var audioFilesUrlStrings: [String] = []
    @Published var drawingData: Data?
}

//
//  Subtask.swift
//  Your Notes
//
//  Created by Franco Marquez on 26/10/23.
//

import Foundation

struct Subtask: Codable, Hashable, Identifiable{
    var id = UUID()
    var name: String
    var isChecked: Bool
}

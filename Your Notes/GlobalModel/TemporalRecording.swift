//
//  TemporalRecording.swift
//  Your Notes
//
//  Created by Franco Marquez on 30/10/23.
//

import Foundation
import AVFoundation
struct TemporalRecording: Hashable, Identifiable{
    let id = UUID().uuidString
    let fileName : String
    let completeTemporalUrl: String
    let asset : AVAsset
}

//
//  GlobalValues.swift
//  Your Notes
//
//  Created by Franco Marquez on 30/10/23.
//

import Foundation

struct GlobalValues{
    
    struct FilledIcons{
        static let imageIcon = "photo.artframe"
        static let subtaskIcon = "list.bullet.circle.fill"
        static let favoriteStar = "star.fill"
        static let pinIcon = "pin.fill"
        static let textIcon = "doc.plaintext.fill"
        static let micIcon = "mic.fill"
        static let brushIcon = "paintbrush.pointed.fill"
        static let cameraIcon = "camera.fill"
        static let square = "square.circle.fill"
        static let Xbutton = "multiply.circle.fill"
        struct Media{
            static let play = "play.circle.fill"
            static let pause = "pause.circle.fill"
        }
    }
    
    struct NoFilledIcons{
        static let micCircle = "mic.circle"
        static let plusSquare = "plus.square"
        static let plusCircle = "plus.circle"
        static let plus = "plus"
        static let square = "square"
        static let lineList = "line.3.horizontal"
        static let checkmarkSquare = "checkmark.square"
        static let glass = "magnifyingglass"
        static let xButton = "x.circle"
        static let favoriteStar = "star"
        static let listBullet = "list.bullet"
    }
    
    struct Strings{
        struct Subtitles{
            static let voicenotes = "Voicenotes"
            static let subtasks = "Subtasks"
            static let images = "Images"
        }
        struct ButtonTitles{
            static let editNote = "Edit Note"
            static let saveChanges = "Save"
            static let cancel = "Cancel"
            static let edit = "Edit"
            static let confirm = "Confirm"
        }
        struct ScreenTitles{
            static let homeScreenTitle = "My Notes"
        }
        static let baseFolderVoicenotes = "VoiceNotes"
        static let dayFormat = "dd-MM-YY 'at' HH-mm-ss"
        
        static let cameraDeniedMessage = "Go to settings and allow camera"
        static let micDeniedMessage = "Go to settings and allow microphone"
        struct Alerts{
            static let EditMessage = "Do you want to edit this note?"
            static let EditTitle = "Edit note?"
            static let SaveMessage = "Are you sure you want to save the changes?"
            static let SaveTitle = "Save changes?"
        }
    }
    
}

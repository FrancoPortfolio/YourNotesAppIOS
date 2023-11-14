//
//  SubtasksSectionExtendedNote.swift
//  Your Notes
//
//  Created by Franco Marquez on 14/11/23.
//

import SwiftUI

struct SubtasksSectionExtendedNote: View{
    
    @Binding var subtasks : [NoteSubtask]?
    var screenMode: ScreenMode
    var doWhenSubtaskTapped : (NoteSubtask) -> ()
    
    
    var body: some View{
        
        VStack{
            if screenMode == .edit || !self.subtasks!.isEmpty{
                Text(GlobalValues.Strings.Subtitles.subtasks)
                    .extendedNoteSubtitle()
                    .padding(.top)
            }
            
            VStack (spacing: 6){
                if let subtasks = self.subtasks, !subtasks.isEmpty{
                    VStack{
                        ForEach(subtasks){ subtask in
                            SubtaskRow(subtask: subtask,
                                       screenMode: self.screenMode,
                                       subtasks: self.$subtasks) { subtask in
                                if let index = self.subtasks!.firstIndex(of: subtask){
                                    withAnimation(.linear){
                                        let subtask = self.subtasks!.remove(at: index)
                                        DataManager.deleteObject(object: subtask)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
                if screenMode == .edit{
                    SubtaskEditorAddForm(subtasks: self.$subtasks)
                }
            }
            
        }
    }
}



struct SubtaskRow: View{
    
    var subtask: NoteSubtask
    var screenMode: ScreenMode
    @Binding var subtasks: [NoteSubtask]?
    var doWhenSubtaskTapped : (NoteSubtask) -> ()
    
    var body: some View{
        HStack(alignment: .center){
            Button {
                doWhenSubtaskTapped(subtask)
            } label: {
                HStack{
                    Image(systemName: subtask.isDone ? GlobalValues.NoFilledIcons.checkmarkSquare : GlobalValues.NoFilledIcons.square)
                        .padding(.trailing)
                    
                    if let taskText = subtask.task{
                        Text(taskText)
                    }
                    
                    Spacer()
                }
                .font(.system(size: 20))
                .foregroundColor(ColorManager.textColor)
                .padding(.vertical,5)
            }
            
            if screenMode == .edit{
                Button{
                    if let index = self.subtasks!.firstIndex(of: subtask){
                        withAnimation(.linear){
                            let subtask = self.subtasks!.remove(at: index)
                            DataManager.deleteObject(object: subtask)
                        }
                    }
                }label:{
                    Image(systemName: GlobalValues.NoFilledIcons.xButton)
                        .iconButton(size: 24)
                }
            }
        }
        .font(.system(size: 20))
        .foregroundColor(ColorManager.textColor)
        .padding(.vertical,5)
    }
}
//
//struct SubtasksSectionExtendedNote_Previews: PreviewProvider {
//    static var previews: some View {
//        SubtasksSectionExtendedNote()
//    }
//}
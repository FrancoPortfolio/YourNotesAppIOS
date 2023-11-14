//
//  ExtendedNoteScreen.swift
//  Your Notes
//
//  Created by Franco Marquez on 6/11/23.
//

import SwiftUI
import PencilKit

struct ExtendedNoteScreen: View {
    
    @StateObject private var viewModel: ExtendedNoteViewModel
    @State private var presentAlertToEdit = false
    @State private var presentAlertToConfirmChanges = false
    
    init(noteId: String) {
        self._viewModel = StateObject(wrappedValue: ExtendedNoteViewModel(noteId: noteId))
    }
    
    var isEditing : Bool{
        return self.viewModel.screenMode == .edit
    }
    
    var body: some View {
        
        ZStack{
            
            ColorManager.backgroundColor.ignoresSafeArea()
            
            ScrollView(.vertical){
                LazyVStack{
                    if isEditing{
                        NoteFormTextField(noteText: self.$viewModel.title,
                                          placeholderText: "Note Title")
                    }
                    //Text
                    VStack{
                        if isEditing{
                            NoteFormTextField(noteText: self.$viewModel.bodyText,
                                              placeholderText: "Note Text",
                                              shouldExpand: true)
                            .padding(.top)
                        }else{
                            if viewModel.bodyText != "" {
                                Text(viewModel.bodyText)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top)
                            }
                        }
                    }
                    //Images
                    ImagesSectionExtendedNote(screenMode: self.viewModel.screenMode,
                                              images: $viewModel.images){ noteImage in
                        //eraseImageTemporally
                        viewModel.eraseImageFromArrayTemp(noteImage: noteImage)
                    }
                    //Subtasks
                    SubtasksSectionExtendedNote(subtasks: self.$viewModel.subtasks,
                                                screenMode: self.viewModel.screenMode) { subtask in
                        viewModel.changeStateSubtask(subtask: subtask, isEditing: self.isEditing)
                    }
                    //Voicenotes
                    
                    RecordingPlayerView(voicenotes: $viewModel.recordings,
                                        noteId: self.viewModel.noteId,
                                        isEditing: self.isEditing,
                                        temporalFilenames: $viewModel.temporalRecording)
                    //Drawing
                    DrawingSectionExtendedNote(noteDrawing: $viewModel.drawing,
                                               actualData: $viewModel.drawingData,
                                               screenMode: self.viewModel.screenMode)
                }
            }
            .padding(.horizontal)
            .scrollIndicators(.hidden)
            .disabled(self.viewModel.isSaving)
            
            if viewModel.isSaving{
                LoadingView()
            }
            
        }
        .navigationBarTitle(isEditing ? "Edit Mode" : viewModel.title)
        .navigationBarTitleDisplayMode(isEditing ? .inline : .large)
        .toolbarBackground(ColorManager.backgroundColor, for: .navigationBar)
        .toolbar {
            
            ToolbarItem{
                menuToolbar
            }
        }
        .alert(GlobalValues.Strings.Alerts.EditTitle, isPresented: $presentAlertToEdit) {
            Button(GlobalValues.Strings.ButtonTitles.cancel, role: .cancel) {}
            Button(GlobalValues.Strings.ButtonTitles.edit, role: ButtonRole.destructive) {
                withAnimation(.linear){
                    self.viewModel.screenMode = .edit
                }
            }
        } message: {
            Text(GlobalValues.Strings.Alerts.EditMessage)
        }
        
        .alert(GlobalValues.Strings.Alerts.SaveTitle, isPresented: $presentAlertToConfirmChanges) {
            Button(GlobalValues.Strings.ButtonTitles.cancel, role: .cancel) {}
            Button(GlobalValues.Strings.ButtonTitles.saveChanges, role: ButtonRole.destructive) {
                //save changes
            }
        } message: {
            Text(GlobalValues.Strings.Alerts.SaveMessage)
        }
    }
}

extension ExtendedNoteScreen{
    private var menuToolbar: some View{
            Menu {
                
                if !isEditing{
                    Button {
                        self.presentAlertToEdit.toggle()
                    } label: {
                        Label(GlobalValues.Strings.ButtonTitles.editNote,
                              systemImage: "pencil")
                    }
                } else {
                    Button {
                        self.viewModel.saveAllData()
                    } label: {
                        Label(GlobalValues.Strings.ButtonTitles.saveChanges,
                              systemImage: "square.and.arrow.down.fill")
                    }

                }
                Button {
                    self.managePin()
                } label: {
                    Label(viewModel.isPinned ? "Unpin note" : "Pin note",
                          systemImage: viewModel.isPinned ? GlobalValues.FilledIcons.pinIcon : "pin")
                }
                
                Button {
                    self.manageFavorite()
                } label: {
                    Label(viewModel.isFavorite ? "Unmark as favorite" : "Mark as favorite",
                          systemImage: self.viewModel.isFavorite ? GlobalValues.FilledIcons.favoriteStar : GlobalValues.NoFilledIcons.favoriteStar)
                }
                
                if isEditing{
                    Button {
                        self.viewModel.reloadInitialValues()
                    } label: {
                        Label("Discard changes", systemImage: GlobalValues.NoFilledIcons.xButton)
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
}

extension ExtendedNoteScreen{
    private func managePin(){
        if self.viewModel.isPinned{
            self.viewModel.unmarkAsPinned()
            return
        }
        self.viewModel.markAsPinned()
    }
    
    private func manageFavorite(){
        if self.viewModel.isFavorite{
            self.viewModel.unmarkAsFavorite()
            return
        }
        self.viewModel.markAsFavorite()
    }
}

enum ScreenMode{
    case display,edit
}

//struct ExtendedNoteScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        ExtendedNoteScreen()
//    }
//}

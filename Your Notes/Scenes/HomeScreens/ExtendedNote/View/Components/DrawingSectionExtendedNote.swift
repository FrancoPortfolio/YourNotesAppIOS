//
//  DrawingSectionExtendedNote.swift
//  Your Notes
//
//  Created by Franco Marquez on 13/11/23.
//

import SwiftUI

struct DrawingSectionExtendedNote: View{
    
    @Binding var actualData: Data
    @State private var showEditionSheet = false
    @State private var presentEraseAlert = false
    @Binding var noteDrawing: NoteDrawing?
    var screenMode: ScreenMode
    var color: Color
    
    init(noteDrawing: Binding<NoteDrawing?>, actualData: Binding<Data>,screenMode: ScreenMode,color: Color){
        self._noteDrawing = noteDrawing
        self._actualData = actualData
        self.screenMode = screenMode
        self.color = color
    }
    
    var body: some View{
        VStack{
            if screenMode == .edit || noteDrawing != nil{
                Text("Drawing")
                    .extendedNoteSubtitle()
            }
            
            if noteDrawing != nil{
                if let noteDrawing{
                    DrawingEditionBody(noteDrawingEntity: noteDrawing,
                                       screenMode: self.screenMode,
                                       colorBackground: self.color) {
                        showEditionSheet.toggle()
                    } doWhenErasing: {
                        eraseDrawing()
                    }
                }
            }
            else{
                if screenMode == .edit{
                    DashedLabelButton(labelTitle: "Add drawing",
                                      systemImageName: GlobalValues.FilledIcons.brushIcon) {
                        self.showEditionSheet.toggle()
                    }
                }

            }
        }
        .sheet(isPresented: $showEditionSheet) {
            DrawingViewForm(data: self.actualData){data in
                manageDrawingData(data: data)
            }
        }
    }
    
    private func manageDrawingData(data: Data){
        
        if self.noteDrawing == nil{
            let entity = NoteDrawing(context: DataManager.standard.container.viewContext)
            
            entity.id = UUID()
            entity.drawingData = data
            
            self.noteDrawing = entity
        }
        
        self.actualData = data
    }
    
    private func eraseDrawing(){
        withAnimation(.interactiveSpring()){
            if let drawing = self.noteDrawing{
                DataManager.deleteObject(object: drawing)
            }
            self.noteDrawing = nil
            self.actualData = Data()
        }
    }
}

struct DrawingEditionBody: View {
    
    @State private var presentEraseAlert = false
    
    var noteDrawingEntity: NoteDrawing
    var screenMode: ScreenMode = .edit
    var colorBackground : Color
    var noteDrawingData: Data?
    var doWhenEditing: () -> ()
    var doWhenErasing: () -> ()
    
    
    var body: some View{
        HStack(spacing: 30){
            Image(uiImage: UIImage.getUIImageFromCanvasData(data: noteDrawingData ?? noteDrawingEntity.drawingData!))
                .drawingOnExtendedNote(color: colorBackground)
            
            if screenMode == .edit{
                VStack(spacing: 50){
                    Button {
                        doWhenEditing()
                    } label: {
                        Image(systemName: "pencil")
                            .iconButton(size: 40)
                    }
                    
                    Button {
                        //erase
                        presentEraseAlert.toggle()
                    } label: {
                        Image(systemName: "trash")
                            .iconButton(size: 40)
                    }
                    
                }
            }
        }.frame(maxWidth: .infinity)
            .padding(.vertical)
            
            .alert("Erase this drawing", isPresented: self.$presentEraseAlert) {
                Button("Erase", role: .destructive) {
                    doWhenErasing()
                }
                Button(GlobalValues.Strings.ButtonTitles.cancel, role: .cancel) {}
            } message: {
                Text("Are you sure you want to erase this drawing?")
            }
    }
    
}

//struct DrawingSectionExtendedNote_Previews: PreviewProvider {
//    static var previews: some View {
//        DrawingSectionExtendedNote()
//    }
//}

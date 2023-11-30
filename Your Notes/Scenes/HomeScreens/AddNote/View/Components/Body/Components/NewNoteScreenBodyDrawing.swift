//
//  NewNoteScreenBodyDrawing.swift
//  Your Notes
//
//  Created by Franco Marquez on 30/11/23.
//

import SwiftUI

struct NewNoteScreenBodyDrawing: View {
    
    @StateObject var viewModel: AddNewNoteViewModel
    @State private var showDrawingEditionSheet = false
    @State private var dataToDisplayDrawing : Data?
    
    var body: some View {
        Text("Drawing")
            .newNoteSubtitle()
        
        VStack{
            if viewModel.noteDrawingTemp == nil{
                DashedLabelButton(labelTitle: "Add drawing",
                                  systemImageName: GlobalValues.FilledIcons.brushIcon) {
                    self.showDrawingEditionSheet.toggle()
                }
            } else {
                if let drawing = viewModel.noteDrawingTemp{
                    DrawingEditionBody(noteDrawingEntity: drawing,
                                       colorBackground: viewModel.getColorView(),
                                       noteDrawingData: viewModel.drawingDataDisplay) {
                        //edit
                        self.showDrawingEditionSheet.toggle()
                    } doWhenErasing: {
                        //erase
                        self.viewModel.eraseTemporalDrawing()
                    }

                }
            }
        }
        .sheet(isPresented: self.$showDrawingEditionSheet) {
            if let drawing = viewModel.noteDrawingTemp,
               let data = drawing.drawingData{
                DrawingViewForm(data: data){ data in
                    viewModel.updateDrawingData(data: data)
                }
            }else{
                DrawingViewForm(data: Data()) { data in
                    viewModel.generateTemporalDrawingEntity(data: data)
                }
            }
        }
    }
}

//struct NewNoteScreenBodyDrawing_Previews: PreviewProvider {
//    static var previews: some View {
//        NewNoteScreenBodyDrawing()
//    }
//}

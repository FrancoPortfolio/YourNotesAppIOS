//
//  DrawingView.swift
//  Your Notes
//
//  Created by Franco Marquez on 23/10/23.
//

import SwiftUI

struct DrawingViewForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var data: Data = Data()
    var doOnFinish : (Data) -> ()
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    doOnFinish(self.data)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Done")
                        .padding()
                })
            }
            
            VStack{ }
                .frame(width: 300, height: 450)
                .background{
                    Color.white
                }
                .overlay {
                    DrawingCanvasViewForm(data: $data)
                }
                .overlay {
                    Rectangle()
                        .stroke(Color.black, lineWidth: 4)
                }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background{
            ColorManager.backgroundColor
        }
    }
}

//
//  NewColorSelector.swift
//  Your Notes
//
//  Created by Franco Marquez on 25/10/23.
//

import SwiftUI

struct NewColorEditor: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel : NewColorEditorViewModel = NewColorEditorViewModel()
    @State private var colorSelected : Color = Color(hex: "#FFFFFF")!
    
    var body: some View {
        Group{
            VStack{
                HStack{
                    HStack(alignment: .center){
                        Text("Selected color")
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                        
                        Circle()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(colorSelected)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    HStack{
                        Text("Change color:")
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                        
                        ColorPicker("", selection: $colorSelected)
                            .frame(width: 50, height: 50)
                    }
                    
                    
                }
                .padding(.top)
                
                Text("Preview: ")
                    .newNoteSubtitle()
                
                NoteColorPreview(color: colorSelected)
                
                    HStack{
                        Spacer()
                        
                        Button(action: {
                            viewModel.saveColorOnCoreData(colorHex: colorSelected.toHexString())
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Save")
                                .font(.system(size: 25))
                                .fontWeight(.bold)
                                .padding()
                        })
                    }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
        }
        .background{
            ColorManager.backgroundColor.ignoresSafeArea()
        }
        .alert("Color is already saved", isPresented: $viewModel.showAlertOfExistingColor) {
            Button("Ok", role: .cancel, action: {})
        } message: { }

    }
}

fileprivate struct NoteColorPreview: View{
    
    var color: Color
    
    var body: some View{
        Group{
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(color)
                .scaledToFit()
                .frame(height: 200)
                .overlay {
                    
                    VStack{
                        PlaceholderRectangle()
                            .frame(width: 160,height: 20)
                            .padding(.top, 30)
                        
                        Spacer()
                        
                        HStack{
                            VStack(spacing:20){
                                PlaceholderRectangle()
                                    .frame(width: 130,height: 20)
                                
                                PlaceholderRectangle()
                                    .frame(width: 130,height: 20)
                                
                                PlaceholderRectangle()
                                    .frame(width: 130,height: 20)
                            }
                            .padding(.leading, 20)
                            Spacer()
                        }
                        Spacer()
                        
                    }
                }
        }
    }
    
}

fileprivate struct PlaceholderRectangle: View{
    
    @State private var startingPoint = UnitPoint(x: 0, y: 0)
    @State private var endPoint = UnitPoint(x: 0.1, y: 0)
    
    var body: some View{
        
        LinearGradient(colors: [Color.gray.opacity(0.2),Color.gray.opacity(0.4),Color.gray.opacity(0.2)],
                       startPoint: startingPoint,
                       endPoint: endPoint)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onAppear{
            withAnimation (.easeIn(duration: 2).repeatForever(autoreverses: false)){
                endPoint = UnitPoint(x: 1, y: 0)
            }
        }

        
    }
    
}

struct NewColorSelector_Previews: PreviewProvider {
    static var previews: some View {
        NewColorEditor()
    }
}

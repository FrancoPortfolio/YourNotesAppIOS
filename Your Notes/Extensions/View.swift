//
//  View.swift
//  Your Notes
//
//  Created by Franco Marquez on 16/10/23.
//

import Foundation
import SwiftUI

enum Log{
    enum LogLevel{
        case info
        case warning
        case error
        
        fileprivate var prefix: String{
            switch self{
            case .info:     return "INFO ℹ️"
            case .error:    return "ERROR ⛔️"
            case .warning:  return "ALERT ⚠️"
            }
        }
    }
    
    struct Context{
        
        let file: String
        let function: String
        let line: Int
        var description: String{return "\((file as NSString).lastPathComponent):\(line) \(function)"}
    }
    
    static func info(_ str:String, file: String = #file, function: String = #function, line: Int = #line){
        let context = Context(file: file, function: function, line: line)
        Log.print(level: .info, str: str, context: context)
    }
    
    static func error(_ str:String, file: String = #file, function: String = #function, line: Int = #line){
        let context = Context(file: file, function: function, line: line)
        Log.print(level: .error, str: str, context: context)
    }
    
    static func warning(_ str:String, file: String = #file, function: String = #function, line: Int = #line){
        let context = Context(file: file, function: function, line: line)
        Log.print(level: .warning, str: str, context: context)
    }
    
    fileprivate static func print(level: LogLevel, str: String, context: Context){
        
        let file = context.file.split(separator: "/").last
        Swift.print("----------------------------------------------------")
        Swift.print("\(level.prefix): \(file!) on \(context.function) line \(context.line): " + str)
        
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    func getFrameBorderPainted() -> some View{
        self
            .overlay {
            Rectangle().stroke(Color.red, lineWidth: 2)
        }
    }
    
}

fileprivate struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

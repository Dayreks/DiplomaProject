//
//  SourceEditorCommand.swift
//  CodeGenerator
//
//  Created by Bohdan Arkhypchuk on 10.12.2023.
//

import Foundation
import XcodeKit
import AppKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        if let builder = MenuManager.find(commandIdentifier: invocation.commandIdentifier) {
            DispatchQueue.main.async {
                builder.build(with: invocation)
            }
        }
        
        completionHandler(nil)
    }
    
//    func createSwiftFile(
//        with text: String,
//        in directory: String,
//        filename: String
//    ) {
//        let fileManager = FileManager.default
//        let filePath = "\(directory)/\(filename).swift"
//
//        if let data = text.data(using: .utf8) {
//            let success = fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
//            if success {
//                print("File created and data written successfully.")
//            } else {
//                print("Failed to create file.")
//            }
//        } else {
//            print("Failed to convert string to data.")
//        }
//
//        if let fileData = fileManager.contents(atPath: filePath) {
//            if let fileContentString = String(data: fileData, encoding: .utf8) {
//                print("File contents:")
//                print(fileContentString)
//            }
//        } else {
//            print("Failed to read file")
//        }
//    }
}

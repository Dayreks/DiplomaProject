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
        
//        let scriptRunner = ScriptRunner()
//        scriptRunner.run(fileName: "FileCreateScript")
//        
        completionHandler(nil)
    }
}


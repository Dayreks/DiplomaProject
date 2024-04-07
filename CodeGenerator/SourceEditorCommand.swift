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
    
    let defaults = UserDefaults(suiteName: "524636QW8M.group.com.bohdanarkhypchuk.ukma.ua.DiplomaProject")
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        if let builder = MenuManager.find(commandIdentifier: invocation.commandIdentifier) {
            DispatchQueue.main.async {
                builder.build()
                
                let customurl = NSURL.init(string: "diplomaProject://")
                NSWorkspace.shared.open(customurl! as URL)
            }
        }
        
        completionHandler(nil)
    }
}


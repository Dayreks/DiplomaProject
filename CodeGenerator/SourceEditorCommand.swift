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
        defaults?.removeObject(forKey: StorageKeys.inputCode)
        defaults?.removeObject(forKey: StorageKeys.outputCode)
        defaults?.removeObject(forKey: StorageKeys.isOutputBlocked)
        
        if let builder = MenuManager.find(commandIdentifier: invocation.commandIdentifier) {
            DispatchQueue.main.async { [weak self] in
                let source = invocation.buffer
                
                guard
                    let selectionRange = source.selections.firstObject as? XCSourceTextRange,
                    let selectedText = source.extractSelectedText(with: selectionRange)
                else {
                    print("No selection")
                    return
                }
                
                self?.defaults?.set(builder.triggerIdentifier.rawValue, forKey: StorageKeys.triggerIdentifier)
                
                switch builder.triggerIdentifier {
                case .methodMacro, .viewCellMacro:
                    self?.defaults?.set(selectedText, forKey: StorageKeys.inputCode)
                    self?.defaults?.set(true, forKey: StorageKeys.isOutputBlocked)
                case .variableInputMacro:
                    self?.defaults?.set(selectedText, forKey: StorageKeys.inputCode)
                    self?.defaults?.set(false, forKey: StorageKeys.isOutputBlocked)
                    
                case .variableOutputMacro:
                    self?.defaults?.set(selectedText, forKey: StorageKeys.outputCode)
                    self?.defaults?.set(false, forKey: StorageKeys.isOutputBlocked)
                }
                
                let customurl = NSURL.init(string: "diplomaProject://")
                NSWorkspace.shared.open(customurl! as URL)
            }
        }
        
        completionHandler(nil)
    }
}


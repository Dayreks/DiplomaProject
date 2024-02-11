//
//  SourceEditorExtension.swift
//  CodeGenerator
//
//  Created by Bohdan Arkhypchuk on 10.12.2023.
//

import Foundation
import XcodeKit

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey : Any]] {
        return MenuManager.builders.map { builder in
            return [
                XCSourceEditorCommandDefinitionKey.nameKey: builder.title,
                XCSourceEditorCommandDefinitionKey.classNameKey: SourceEditorCommand.className(),
                XCSourceEditorCommandDefinitionKey.identifierKey: Helper.namespacedIdentifier(identifier: builder.title)
            ]
        }
    }
    
    /*
    func extensionDidFinishLaunching() {
        // If your extension needs to do any work at launch, implement this optional method.
    }
    */
    
    /*
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
        // If your extension needs to return a collection of command definitions that differs from those in its Info.plist, implement this optional property getter.
        return []
    }
    */
    
}

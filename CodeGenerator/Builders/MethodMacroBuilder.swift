//
//  MacroBuilder.swift
//  CodeGenerator
//
//  Created by Bohdan Arkhypchuk on 14.01.2024.
//

import Foundation
import XcodeKit
import AppKit

class MethodMacroBuilder: Builder {
    
    var title: String {
        "Generate Method Macro"
    }
    
    func build(with invocation: XCSourceEditorCommandInvocation) {
        let source = invocation.buffer
        
        guard
            let selectionRange = source.selections.firstObject as? XCSourceTextRange,
            let selectedText = source.extractSelectedText(with: selectionRange)
        else {
            print("No selection")
            return
        }
        
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        
        pasteboard.setString(
            createMacro(
                with: selectedText,
                name: "stringify",
                type: .freestanding
            ),
            forType: .string
        )
    }
    
    func createMacro(
        with content: String,
        name: String,
        type: MacroType
    ) -> String {
        return """
        \(type.rawValue)(expression)
        public macro \(name)<T>(_ value: T) -> (T, String) = #externalMacro(module: "CustomMacroMacros", type: "\(name.capitalized)Macro")
        
        public struct \(name.capitalized)Macro: ExpressionMacro {
        
            public static func expansion(
                of node: some FreestandingMacroExpansionSyntax,
                in context: some MacroExpansionContext
            ) -> ExprSyntax {
        
                return "\(content)"
            }
        }

        @main
        struct CustomMacroPlugin: CompilerPlugin {
            let providingMacros: [Macro.Type] = [
                \(name.capitalized)Macro.self,
            ]
        }
        """
    }
    
    
}

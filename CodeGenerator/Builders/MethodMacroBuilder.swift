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
                name: "methodify",
                type: .attached
            ),
            forType: .string
        )
    }

    private func createMacro(
        with content: String,
        name: String,
        type: MacroType
    ) -> String {
        """
            \(type.rawValue)(member, names: arbitrary)
            public macro \(name)() = #externalMacro(module: "CustomMacroMacros", type: "\(name.capitalized)Macro")
            
            public struct \(name.capitalized)Macro: MemberMacro {
            
                    public static func expansion(
                        of node: AttributeSyntax,
                        providingMembersOf declaration: some DeclGroupSyntax,
                        in context: some MacroExpansionContext
                    ) throws -> [DeclSyntax] {
                        let contentString =
            \"\"\"
            \(content)
            \"\"\"
                        return [.init(stringLiteral: contentString)]
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

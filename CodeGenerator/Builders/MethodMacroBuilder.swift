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
            createMacro(with: selectedText, type: .attached),
            forType: .string
        )
    }

    private func createMacro(with content: String, type: MacroType) -> String {
        let defaults = UserDefaults(suiteName: "524636QW8M.group.com.bohdanarkhypchuk.ukma.ua.DiplomaProject")
        
        guard
            checkIfMethodSelected(with: content),
            let name = extractFunctionName(from: content),
            let macroModuleName = defaults?.object(forKey: "macroModuleName") as? String
        else {
            return ""
        }
        
        return """
            \(type.rawValue)(member, names: arbitrary)
            public macro \(name.lowerCasedFirst)() = #externalMacro(module: "\(macroModuleName)", type: "\(name.capitalizedFirst)Macro")
            
            public struct \(name.capitalizedFirst)Macro: MemberMacro {
            
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
                    \(name.capitalizedFirst)Macro.self,
                ]
            }
            """
    }

    func checkIfMethodSelected(with content: String) -> Bool {
        // Regex pattern to find a Swift method declaration.
        // This pattern looks for:
        // - Optional access modifiers (public, private, etc.)
        // - The "func" keyword,
        // - Any word character (the method name),
        // - Opening and closing parentheses for parameters (may include other characters for types),
        // - An optional return type (-> Type),
        // - And then checks for the presence of opening and closing braces with content.
        // Note: This is a simplified pattern and may not cover all valid Swift method syntaxes.
        let pattern = "(public|private|internal)?\\s*func\\s+\\w+\\s*\\(.*\\)\\s*(->\\s*\\w+)?\\s*\\{.*\\}"
        
        // Use regex to find matches in the content
        if let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) {
            let range = NSRange(location: 0, length: content.utf16.count)
            let matches = regex.matches(in: content, options: [], range: range)
            
            // If there's at least one match, we consider the content as valid
            return !matches.isEmpty
        }
        
        return false
    }
    
    func extractFunctionName(from content: String) -> String? {
        // Regex pattern to extract a function name.
        // This pattern captures:
        // - The function name immediately following the "func" keyword and whitespace.
        // - It assumes the function name ends before the opening parenthesis of the parameter list.
        let pattern = "func\\s+(\\w+)\\s*\\("
        
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let range = NSRange(location: 0, length: content.utf16.count)
            if let match = regex.firstMatch(in: content, options: [], range: range) {
                if let functionNameRange = Range(match.range(at: 1), in: content) {
                    return String(content[functionNameRange])
                }
            }
        }
        
        return nil
    }

}

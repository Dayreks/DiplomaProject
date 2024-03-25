//
//  CellViewBuilder.swift
//  CodeGenerator
//
//  Created by B-Arkhypchuk on 12.03.2024.
//

import Foundation
import XcodeKit
import AppKit

class ViewCellBuilder: Builder {
    
    var title: String {
        "Generate View Cell Macro"
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
            createMacro(with: selectedText, type: .freestanding),
            forType: .string
        )
    }
    
    private func createMacro(with content: String, type: MacroType) -> String {
        let defaults = UserDefaults(suiteName: "524636QW8M.group.com.bohdanarkhypchuk.ukma.ua.DiplomaProject")
        
        guard
            checkIfViewSelected(with: content),
            let name = extractViewClassName(from: content),
            let moduleName = defaults?.object(forKey: "moduleName") as? String,
            let macroName = defaults?.object(forKey: "macroName") as? String
        else {
            return ""
        }
        
        return """
            \(type.rawValue)(declaration, names: arbitrary)
            public macro \(macroName.lowerCasedFirst)() = #externalMacro(module: "\(moduleName)", type: "\(macroName.capitalizedFirst)Macro")
            
            public struct \(macroName.capitalizedFirst)Macro: DeclarationMacro {
                
                public static func expansion(
                    of node: some FreestandingMacroExpansionSyntax,
                    in context: some MacroExpansionContext
                ) throws -> [DeclSyntax] {
                    return [
                        .init(stringLiteral:
                    \"\"\"
                      class \(name.capitalizedFirst)Cell: UITableViewCell {
                          
                          let mainView = \(name.capitalizedFirst)()
                          
                          override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
                              super.init(style: style, reuseIdentifier: reuseIdentifier)
                              
                              setupLayout()
                          }
                          
                          required init?(coder: NSCoder) {
                              fatalError("init(coder:) has not been implemented")
                          }
                          
                          private func setupLayout() {
                              contentView.addSubview(view)
                              view.translatesAutoresizingMaskIntoConstraints = false
                              NSLayoutConstraint.activate([
                                  view.topAnchor.constraint(equalTo: contentView.topAnchor),
                                  view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                  view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                  view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
                              ])
                          }
                      }
                    \"\"\"
                    )]
                }
            }
            
            @main
            struct CustomMacroPlugin: CompilerPlugin {
                let providingMacros: [Macro.Type] = [
                    \(macroName.capitalizedFirst)Macro.self,
                ]
            }
            """
    }
    
    func checkIfViewSelected(with content: String) -> Bool {
        // Regex pattern to find a class declaration that conforms to UIView, possibly with modifiers.
        // This pattern looks for:
        // - Optional class modifiers (final, public, private, internal) before the class keyword,
        // - The "class" keyword,
        // - Any word character (the class name),
        // - A colon, optional whitespace, and then "UIView" (or something ending with UIView for subclasses),
        // - And then checks for the presence of opening and closing braces.
        let pattern = "(final\\s+)?(public\\s+|private\\s+|internal\\s+|fileprivate\\s+|open\\s+)?class\\s+\\w+\\s*:\\s*\\w*UIView\\b.*\\{.*\\}"
        
        if let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) {
            let range = NSRange(location: 0, length: content.utf16.count)
            let matches = regex.matches(in: content, options: [], range: range)
            
            // If there's at least one match, we consider the content as valid
            return !matches.isEmpty
        }
        
        return false
    }
    
    func extractViewClassName(from content: String) -> String? {
        // Regex pattern to extract the class name for a class that conforms to UIView.
        // This pattern captures:
        // - The class name immediately following the "class" keyword and whitespace,
        // - Followed by optional whitespace,
        // - Followed by a colon and optional whitespace,
        // - Then capturing the class name if it directly inherits from UIView or conforms to a protocol that implies UIView.
        let pattern = "class\\s+(\\w+)\\s*:\\s*\\w*UIView\\b"
        
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let range = NSRange(location: 0, length: content.utf16.count)
            if let match = regex.firstMatch(in: content, options: [], range: range) {
                if let classNameRange = Range(match.range(at: 1), in: content) {
                    return String(content[classNameRange])
                }
            }
        }
        
        return nil
    }
}


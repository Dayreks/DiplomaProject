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
            createMacro(
                with: selectedText,
                name: "custom",
                type: .freestanding
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
            \(type.rawValue)(declaration, names: arbitrary)
            public macro \(name)Cell() = #externalMacro(module: "CustomMacroMacros", type: "\(name.capitalized)Macro")
            
            public struct \(name.capitalized)Macro: DeclarationMacro {
                
                public static func expansion(
                    of node: some FreestandingMacroExpansionSyntax,
                    in context: some MacroExpansionContext
                ) throws -> [DeclSyntax] {
                    return [
                        .init(stringLiteral:
                    \"\"\"
                      class \(name.capitalized)Cell: UITableViewCell {
                          
                          let mainView = \(name.capitalized)()
                          
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
                    \(name.capitalized)Macro.self,
                ]
            }
            """
    }
}


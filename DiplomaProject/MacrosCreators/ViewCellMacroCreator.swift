//
//  ViewCellMacroCreator.swift
//  DiplomaProject
//
//  Created by Bohdan Arkhypchuk on 07.04.2024.
//

import Foundation

final class ViewCellMacroCreator: MacrosCreator {
    
    private let defaults = UserDefaults(suiteName: "524636QW8M.group.com.bohdanarkhypchuk.ukma.ua.DiplomaProject")
    
    func createMacro(
        inputCode: String,
        outputCode: String?,
        moduleName: String,
        macroName: String
    ) throws -> String {
        guard !inputCode.isEmpty else { throw CodeGenerationError.emptyInput }
        guard !moduleName.isEmpty else { throw CodeGenerationError.emptyModuleName }
        guard !macroName.isEmpty else { throw CodeGenerationError.enmptyMacroName }
        guard let name = extractViewClassName(from: inputCode) else { throw CodeGenerationError.incorrectFormat }
    
        let parsedInput = DeclSyntax(stringLiteral: inputCode)
        guard parsedInput.declType == .class else { throw CodeGenerationError.unexpectedDeclarations }
        
        return """
            @freestanding(declaration, names: arbitrary)
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

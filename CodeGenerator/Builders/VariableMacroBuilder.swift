//
//  VariableMacroBuilder.swift
//  CodeGenerator
//
//  Created by Bohdan Arkhypchuk on 23.03.2024.
//

import Foundation
import XcodeKit
import AppKit

class VariableMacroBuilder: Builder {
    
    var title: String {
        "Generate Variable Macro"
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
            (try? createMacro(with: selectedText, type: .attached)) ?? "",
            forType: .string
        )
    }
    
    private func createMacro(with content: String, type: MacroType) throws -> String {
        let defaults = UserDefaults(suiteName: "524636QW8M.group.com.bohdanarkhypchuk.ukma.ua.DiplomaProject")
        
        guard
            let inputCode = defaults?.object(forKey: "inputCode") as? String,
            let outputCode = defaults?.object(forKey: "outputCode") as? String,
            let moduleName = defaults?.object(forKey: "moduleName") as? String,
            let macroName = defaults?.object(forKey: "macroName") as? String
        else {
            return ""
        }
        
        let parsedInput = DeclSyntax(stringLiteral: inputCode)
        let parsedOutput = DeclSyntax(stringLiteral: outputCode)
        
       
        switch (parsedInput.declType, parsedOutput.declType) {
        case (.variable, .function):
            guard
                let variableSyntax = parsedInput.as(VariableDeclSyntax.self),
                let funcitonSyntax = parsedOutput.as(FunctionDeclSyntax.self),
                let binding = variableSyntax.bindings.first,
                let identifier = binding.pattern.as(IdentifierPatternSyntax.self)
            else {
                break
            }
            
            let propertyName = identifier.identifier.text
            let propertyType = binding.typeAnnotation?.type.description ?? "Type"
            
            let funcVisitor = try FuncVisitor(source: outputCode)
            let methodName = funcitonSyntax.name
            let methodParameters = funcitonSyntax.signature.parameterClause.parameters.map { ($0.firstName, $0.secondName, $0.type)}
            let methodStatements = funcitonSyntax.body?.statements
            
            if funcVisitor.declarationReferences.map({ $0.baseName.text }).contains(propertyName) {
                var resultMethod = outputCode
                
                
            }
            
            return """
            \(type.rawValue)(peer, names: arbitrary)
            public macro \(macroName.lowerCasedFirst)() = #externalMacro(module: "\(moduleName)", type: "\(macroName.capitalizedFirst)Macro")
                    
            public struct \(macroName.capitalizedFirst)Macro: PeerMacro {
                
                public static func expansion(
                    of node: AttributeSyntax,
                    providingPeersOf declaration: some DeclSyntaxProtocol,
                    in context: some MacroExpansionContext
                ) throws -> [DeclSyntax]  {
                    guard let variableDecl = declaration.as(VariableDeclSyntax.self) else {
                        throw MacroError.notVariable
                    }
                                    
                    // Extract property name and type
                    guard let binding = variableDecl.bindings.first,
                    let identifier = binding.pattern.as(IdentifierPatternSyntax.self) else {
                        throw MacroError.notValidIdentifier
                    }

                    let propertyName = identifier.identifier.text
                    let propertyType = binding.typeAnnotation?.type.description ?? "Type"

                    // Generate the setter method code
                    let methodName = "set\(propertyName.capitalized)"
                    let methodCode = \"\"\"
                    func \(methodName)(_ newValue: \(propertyType)) {
                        self.\(propertyName) = newValue
                    }
                    \"\"\"
                                    
                        return [DeclSyntax(stringLiteral: methodCode)]
                }
            }
                        
            @main
            struct CustomMacroPlugin: CompilerPlugin {
                let providingMacros: [Macro.Type] = [
                    \(macroName.capitalizedFirst)Macro.self,
                ]
            }
            """
            
        default:
            return ""
        }
        
        return ""
    }
}


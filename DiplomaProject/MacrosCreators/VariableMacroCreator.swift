//
//  VariableMacroCreator.swift
//  DiplomaProject
//
//  Created by Bohdan Arkhypchuk on 07.04.2024.
//

import Foundation

final class VariableMacroCreator: MacrosCreator {
    
    private let defaults = UserDefaults(suiteName: "524636QW8M.group.com.bohdanarkhypchuk.ukma.ua.DiplomaProject")
    
    func createMacro(
        inputCode: String,
        outputCode: String?,
        moduleName: String,
        macroName: String
    ) throws -> String {
        guard !inputCode.isEmpty else { throw CodeGenerationError.emptyInput }
        guard let outputCode, !outputCode.isEmpty else { throw CodeGenerationError.emptyOutput }
        guard !moduleName.isEmpty else { throw CodeGenerationError.emptyModuleName }
        guard !macroName.isEmpty else { throw CodeGenerationError.enmptyMacroName }
        
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
                throw CodeGenerationError.incorrectFormat
            }
            
            let funcVisitor = try FuncVisitor(source: outputCode)
            var macroInsertionCode = """
            guard let variableDecl = declaration.as(VariableDeclSyntax.self) else {
                                    fatalError()
            }
                                                
            // Extract property name and type
            guard
                let binding = variableDecl.bindings.first,
                let identifier = binding.pattern.as(IdentifierPatternSyntax.self)
            else {
                    fatalError()
            }

            """
            
            
            var propertyName = identifier.identifier.text
            
            if funcVisitor.declarationReferences.map({ $0.baseName.text }).contains(identifier.identifier.text) && funcVisitor.declarationReferences.map({ $0.baseName.text }).contains("self") {
                macroInsertionCode.append("\nlet propertyName = identifier.identifier.text")
                propertyName = "\\(propertyName)"
            }
            
            var methodName = funcitonSyntax.name.text.lowercased()
            if methodName.contains(identifier.identifier.text) {
                methodName = methodName.replacingOccurrences(of: identifier.identifier.text, with: propertyName)
                macroInsertionCode.append("\nlet methodName = \"\(methodName)\"")
                methodName = "\\(methodName)"
            }
            
            let methodParameters = funcitonSyntax.signature.parameterClause.parameters.map { ($0.firstName, $0.secondName, $0.type)}
            
            var propertyType = binding.typeAnnotation?.type.description.trimmingTrailingWhitespace() ?? "Type"
            if
                let methodParameter = methodParameters
                    .first(where: { parameter in
                        funcVisitor.declarationReferences.map({ $0.baseName.text }).contains(where: { varDeclararion in
                            parameter.0.text == varDeclararion || parameter.1?.text == varDeclararion
                        })
                    }),
                methodParameter.2.description == propertyType
            {
                macroInsertionCode.append("\nlet propertyType = binding.typeAnnotation?.type.description ?? \"Type\"")
                propertyType = "\\(propertyType)"
            } else {
                throw CodeGenerationError.typeMissMatch
            }
            
            return """
            @attached(peer, names: arbitrary)
            public macro \(macroName.lowerCasedFirst)() = #externalMacro(module: "\(moduleName)", type: "\(macroName.capitalizedFirst)Macro")
                    
            public struct \(macroName.capitalizedFirst)Macro: PeerMacro {
                
                public static func expansion(
                    of node: AttributeSyntax,
                    providingPeersOf declaration: some DeclSyntaxProtocol,
                    in context: some MacroExpansionContext
                ) throws -> [DeclSyntax]  {
                    \(macroInsertionCode)
            
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
    }
}

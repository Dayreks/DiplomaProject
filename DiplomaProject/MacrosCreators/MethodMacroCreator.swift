//
//  MethodMacroCreator.swift
//  DiplomaProject
//
//  Created by Bohdan Arkhypchuk on 07.04.2024.
//

import Foundation

final class MethodMacroCreator: MacrosCreator {
    
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
        
        
        let parsedInput = DeclSyntax(stringLiteral: inputCode)
        guard parsedInput.declType == .function else { throw CodeGenerationError.unexpectedDeclarations }
        
        return """
            @attached(member, names: arbitrary)
            public macro \(macroName.lowerCasedFirst)() = #externalMacro(module: "\(moduleName)", type: "\(macroName.capitalizedFirst)Macro")
            
            public struct \(macroName.capitalizedFirst)Macro: MemberMacro {
            
                    public static func expansion(
                        of node: AttributeSyntax,
                        providingMembersOf declaration: some DeclGroupSyntax,
                        in context: some MacroExpansionContext
                    ) throws -> [DeclSyntax] {
                        let contentString =
            \"\"\"
            \(inputCode)
            \"\"\"
                        return [.init(stringLiteral: contentString)]
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
}

//
//  CodeGenerationError.swift
//  CodeGenerator
//
//  Created by Bohdan Arkhypchuk on 07.04.2024.
//

import Foundation

enum CodeGenerationError: Error {
    
    case emptyInput, emptyOutput, enmptyMacroName, emptyModuleName, typeMissMatch, incorrectFormat, unexpectedDeclarations
    
    var localizedDescription: String {
        switch self {
        case .emptyInput:
            "The input is empty"
        case .emptyOutput:
            "The output is empty"
        case .typeMissMatch:
            "The input and output expected type missmatch"
        case .incorrectFormat:
            "Incorrect code format"
        case .enmptyMacroName:
            "The macro name is empty"
        case .emptyModuleName:
            "The module name is empty"
        case .unexpectedDeclarations:
            "The declarations are not matching the extension action"
        }
    }
}

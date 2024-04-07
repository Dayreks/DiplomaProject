//
//  VariableMacroBuilder.swift
//  CodeGenerator
//
//  Created by Bohdan Arkhypchuk on 23.03.2024.
//

import Foundation

class VariableMacroInputBuilder: Builder {
    
    var title: String {
        "Generate Variable Macro with Input"
    }

    var triggerIdentifier: TriggerIdentifier {
        .variableInputMacro
    }
}


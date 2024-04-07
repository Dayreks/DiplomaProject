//
//  VariableMacroOutputBuilder.swift
//  CodeGenerator
//
//  Created by Bohdan Arkhypchuk on 07.04.2024.
//

import Foundation

class VariableMacroOutputBuilder: Builder {
    
    var title: String {
        "Generate Variable Macro with Output"
    }
    
    var triggerIdentifier: TriggerIdentifier {
        .variableOutputMacro
    }
}

//
//  MacrosCreator.swift
//  DiplomaProject
//
//  Created by Bohdan Arkhypchuk on 07.04.2024.
//

import Foundation

public protocol MacrosCreator {
    
    func createMacro(
        inputCode: String,
        outputCode: String?,
        moduleName: String,
        macroName: String
    ) throws -> String
}

//
//  Modle.swift
//  DiplomaProject
//
//  Created by Bohdan Arkhypchuk on 07.04.2024.
//

import Foundation

final class ViewModel: ObservableObject {
    
    @Published var moduleName: String = ""
    @Published var macroName: String = ""
    @Published var inputCode: String
    @Published var outputCode: String
    @Published var resultPreview: String = ""
    
    @Published var showingErrorAlert = false
    @Published var errorMessage: String? = ""
    
    @Published var isOutputBlocked: Bool
    
    private var defaults = UserDefaults(suiteName: "524636QW8M.group.com.bohdanarkhypchuk.ukma.ua.DiplomaProject")
    
    init() {
        inputCode =  defaults?.string(forKey: StorageKeys.inputCode)?.trimmingCharacters(in: [" ", "\n"]) ?? ""
        outputCode =  defaults?.string(forKey: StorageKeys.outputCode)?.trimmingCharacters(in: [" ", "\n"]) ?? ""
        isOutputBlocked = defaults?.bool(forKey: StorageKeys.isOutputBlocked) ?? false
    }
    
    func buildMacro() {
        guard let creator: MacrosCreator = getCurrentMacroCreator() else { return }
        
        do {
            resultPreview = try creator.createMacro(
                inputCode: inputCode,
                outputCode: outputCode,
                moduleName: moduleName,
                macroName: macroName
            )
        } catch {
            self.errorMessage = (error as? CodeGenerationError)?.message
            self.showingErrorAlert = true
        }
    }
    
    private func getCurrentMacroCreator() -> MacrosCreator? {
        guard
            let identifier: String = defaults?.string(forKey: StorageKeys.triggerIdentifier),
            let triggerIdentifier = TriggerIdentifier(rawValue: identifier)
        else {
            return nil
        }
        
        switch triggerIdentifier {
        case .methodMacro:
            return MethodMacroCreator()
        case .viewCellMacro:
            return ViewCellMacroCreator()
        case .variableInputMacro, .variableOutputMacro:
            return VariableMacroCreator()
        }
    }
}

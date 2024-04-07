//
//  Modle.swift
//  DiplomaProject
//
//  Created by Bohdan Arkhypchuk on 07.04.2024.
//

import Foundation

final class ViewModel: ObservableObject {
    
    @Published var moduleName: String
    @Published var macroName: String
    @Published var inputCode: String
    @Published var outputCode: String
    @Published var resultPreview: String
    
    @Published var showingErrorAlert = false
    @Published var errorMessage: String = ""
    
    private var defaults = UserDefaults(suiteName: "524636QW8M.group.com.bohdanarkhypchuk.ukma.ua.DiplomaProject")
    
    init() {
        moduleName = defaults?.string(forKey: StorageKeys.moduleName) ?? ""
        macroName = defaults?.string(forKey: StorageKeys.macroName) ?? ""
        inputCode = defaults?.string(forKey: StorageKeys.inputCode) ?? ""
        outputCode = defaults?.string(forKey: StorageKeys.outputCode) ?? ""
        resultPreview = ""
    }
    
    func buildMacro() {
        defaults?.removeObject(forKey: StorageKeys.resultPreview)
        defaults?.removeObject(forKey: StorageKeys.moduleName)
        defaults?.removeObject(forKey: StorageKeys.macroName)
        defaults?.removeObject(forKey: StorageKeys.inputCode)
        defaults?.removeObject(forKey: StorageKeys.outputCode)
        
        save()
        
        resultPreview = defaults?.string(forKey: StorageKeys.resultPreview) ?? ""
        
        let creator = VariableMacroCreator()
        
        do {
            resultPreview = try creator.createMacro(
                inputCode: inputCode,
                outputCode: outputCode,
                moduleName: moduleName,
                macroName: macroName
            )
        } catch {
            self.errorMessage = error.localizedDescription
            self.showingErrorAlert = true
        }
        
    }
    
    private func save() {
        defaults?.set(moduleName, forKey: StorageKeys.moduleName)
        defaults?.set(macroName, forKey: StorageKeys.macroName)
        defaults?.set(inputCode, forKey: StorageKeys.inputCode)
        defaults?.set(outputCode, forKey: StorageKeys.outputCode)
    }
}

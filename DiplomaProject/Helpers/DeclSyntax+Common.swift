//
//  DeclSyntax+Common.swift
//  CodeGenerator
//
//  Created by Bohdan Arkhypchuk on 24.03.2024.
//

import Foundation


extension DeclSyntax {
    
    var declType: DeclType? {
        if let _ = self.as(VariableDeclSyntax.self) {
            return .variable
        }
        
        if let _ = self.as(FunctionDeclSyntax.self) {
            return .function
        }
        
        if let _ = self.as(ClassDeclSyntax.self) {
            return .class
        }
        
        if let _ = self.as(StructDeclSyntax.self) {
            return .structure
        }
        
        if let _ = self.as(EnumDeclSyntax.self) {
            return .enum
        }
        
        return nil
    }
}

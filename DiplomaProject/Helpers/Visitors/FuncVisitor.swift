//
//  FuncVisitor.swift
//  CodeGenerator
//
//  Created by Bohdan Arkhypchuk on 24.03.2024.
//

import Foundation

class FuncVisitor: SyntaxVisitor {
    
    var functions = [FunctionDeclSyntax]()
    var declarationReferences = [DeclReferenceExprSyntax]()
    
    init(source: String) throws {
        super.init(viewMode: .sourceAccurate)
        let sourceFile = Parser.parse(source: source)
        walk(sourceFile)
    }
    
    // MARK: - SyntaxVisitor
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        functions.append(node)
        return .visitChildren
    }
    
    override func visit(_ node: DeclReferenceExprSyntax) -> SyntaxVisitorContinueKind {
        declarationReferences.append(node)
        return .skipChildren
    }
}

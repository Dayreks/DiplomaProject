//
//  XCSourceTextBuffer+Extension.swift
//  CodeGenerator
//
//  Created by Bohdan Arkhypchuk on 11.02.2024.
//

import XcodeKit

extension XCSourceTextBuffer {
    
    func extractSelectedText(with range: XCSourceTextRange) -> String? {
        let startIndex = range.start.line
        let endIndex = range.end.line
        let selectedRange = NSRange(location: startIndex, length: 1 + endIndex - startIndex)
        
        guard let selectedLines = lines.subarray(with: selectedRange) as? [String] else { return nil }

        return selectedLines.joined()
    }
}

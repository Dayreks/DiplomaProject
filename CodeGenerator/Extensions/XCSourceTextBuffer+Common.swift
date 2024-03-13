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
        
        // Ensure the start and end indices are within the bounds of the lines array.
        guard startIndex >= 0, endIndex < self.lines.count else { return nil }

        // Extract the selected lines. The Swift Array slicing syntax cannot be directly used on NSArray,
        // so we convert the relevant part of the NSArray to a Swift Array of Strings.
        let selectedLines = (self.lines as NSArray).subarray(with: NSRange(location: startIndex, length: endIndex - startIndex + 1)) as? [String]
        
        // Join the selected lines into a single string and return it.
        return selectedLines?.joined()
    }
}


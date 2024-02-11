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

//        var extractedText = ""
//
//        for lineIndex in startLine...endLine {
//            if let line = lines[lineIndex] as? String {
//                if lineIndex == startLine && lineIndex == endLine {
//                    // The selection is within a single line
//                    let startIndex = line.index(line.startIndex, offsetBy: startColumn)
//                    let endIndex = line.index(line.startIndex, offsetBy: endColumn)
//                    extractedText = String(line[startIndex..<endIndex])
//                } else if lineIndex == startLine {
//                    // The first line of the selection
//                    let startIndex = line.index(line.startIndex, offsetBy: startColumn)
//                    extractedText += String(line[startIndex...])
//                } else if lineIndex == endLine {
//                    // The last line of the selection
//                    let endIndex = line.index(line.startIndex, offsetBy: endColumn)
//                    extractedText += "\n" + String(line[..<endIndex])
//                } else {
//                    // Full line is selected
//                    extractedText += "\n" + line
//                }
//            }
//        }

        return selectedLines.joined()
    }
}

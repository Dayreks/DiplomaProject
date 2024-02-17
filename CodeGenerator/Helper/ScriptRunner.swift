//
//  ScriptRunner.swift
//  XcodeWayExtensions
//
//  Created by Khoa Pham on 18.10.2017.
//  Copyright © 2017 Fantageek. All rights reserved.
//

import AppKit
import Carbon

class ScriptRunner {
    var scriptPath: URL? {
        try? FileManager.default.url(
            for: .applicationScriptsDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
    }
    
    func fileScriptPath(fileName: String) -> URL? {
        scriptPath?
            .appendingPathComponent(fileName)
            .appendingPathExtension("scpt")
    }
    
    func eventDescriptior(functionName: String) -> NSAppleEventDescriptor {
        var psn = ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kCurrentProcess))
        let target = NSAppleEventDescriptor(
            descriptorType: typeProcessSerialNumber,
            bytes: &psn,
            length: MemoryLayout<ProcessSerialNumber>.size
        )
        
        let event = NSAppleEventDescriptor(
            eventClass: UInt32(kASAppleScriptSuite),
            eventID: UInt32(kASSubroutineEvent),
            targetDescriptor: target,
            returnID: Int16(kAutoGenerateReturnID),
            transactionID: Int32(kAnyTransactionID)
        )
        
        let function = NSAppleEventDescriptor(string: functionName)
        event.setParam(function, forKeyword: AEKeyword(keyASSubroutineName))
        
        return event
    }
    
    func run(functionName: String) {
        guard let filePath = fileScriptPath(fileName: "CodeGeneratorScript") else {
            return
        }
        
        guard FileManager.default.fileExists(atPath: filePath.path) else {
            return
        }
        
        guard let script = try? NSUserAppleScriptTask(url: filePath) else {
            return
        }
        
        let event = eventDescriptior(functionName: functionName)
        script.execute(withAppleEvent: event, completionHandler: { _, error in
            if let error = error {
                print(error)
            }
        })
    }
}

//    func createSwiftFile(
//        with text: String,
//        in directory: String,
//        filename: String
//    ) {
//        let fileManager = FileManager.default
//        let filePath = "\(directory)/\(filename).swift"
//
//        if let data = text.data(using: .utf8) {
//            let success = fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
//            if success {
//                print("File created and data written successfully.")
//            } else {
//                print("Failed to create file.")
//            }
//        } else {
//            print("Failed to convert string to data.")
//        }
//
//        if let fileData = fileManager.contents(atPath: filePath) {
//            if let fileContentString = String(data: fileData, encoding: .utf8) {
//                print("File contents:")
//                print(fileContentString)
//            }
//        } else {
//            print("Failed to read file")
//        }
//    }

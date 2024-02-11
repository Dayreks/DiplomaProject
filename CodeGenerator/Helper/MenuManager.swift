//
//  MenuManager.swift
//  XcodeWay
//
//  Created by Khoa Pham on 22/07/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation

struct MenuManager {
    
    static let builders: [Builder] = [
        MethodMacroBuilder()
    ]
    
    static func find(commandIdentifier: String) -> Builder? {
        for builder in builders {
            if Helper.namespacedIdentifier(identifier: builder.title) == commandIdentifier {
                return builder
            }
        }
        
        return nil
    }
}

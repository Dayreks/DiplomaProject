//
//  String+Commnon.swift
//  CodeGenerator
//
//  Created by Bohdan Arkhypchuk on 13.03.2024.
//

import Foundation

extension String {
    
    var capitalizedFirst: String {
        return self.prefix(1).capitalized + self.dropFirst()
    }
    
    var lowerCasedFirst: String {
        return self.prefix(1).lowercased() + self.dropFirst()
    }
}

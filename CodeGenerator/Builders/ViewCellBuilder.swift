//
//  CellViewBuilder.swift
//  CodeGenerator
//
//  Created by B-Arkhypchuk on 12.03.2024.
//

import Foundation

class ViewCellBuilder: Builder {
    
    var title: String {
        "Generate View Cell Macro"
    }
    
    var triggerIdentifier: TriggerIdentifier {
        .viewCellMacro
    }
    
}


//
//  Navigator.swift
//  XcodeWay
//
//  Created by Khoa Pham on 30/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import XcodeKit

protocol Builder {
    
    var title: String { get }
    func build(with invocation: XCSourceEditorCommandInvocation)
}

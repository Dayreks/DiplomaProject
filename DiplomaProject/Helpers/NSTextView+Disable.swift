//
//  NSTextView+Disable.swift
//  DiplomaProject
//
//  Created by Bohdan Arkhypchuk on 24.03.2024.
//

import SwiftUI

extension NSTextView {
    open override var frame: CGRect {
        didSet {
            self.isAutomaticQuoteSubstitutionEnabled = false
        }
    }
}

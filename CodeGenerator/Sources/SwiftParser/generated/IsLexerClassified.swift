//// Automatically generated by generate-swift-syntax
//// Do not edit directly!
//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

#if swift(>=6)
public import SwiftSyntax
#else
import SwiftSyntax
#endif

extension Keyword {
  /// Whether the token kind is switched from being an identifier to being a keyword in the lexer.
  /// This is true for keywords that used to be considered non-contextual.
  var isLexerClassified: Bool {
    switch self {
    case .Any:
      return true
    case .as:
      return true
    case .associatedtype:
      return true
    case .break:
      return true
    case .case:
      return true
    case .catch:
      return true
    case .class:
      return true
    case .continue:
      return true
    case .default:
      return true
    case .defer:
      return true
    case .deinit:
      return true
    case .do:
      return true
    case .else:
      return true
    case .enum:
      return true
    case .extension:
      return true
    case .fallthrough:
      return true
    case .false:
      return true
    case .fileprivate:
      return true
    case .for:
      return true
    case .func:
      return true
    case .guard:
      return true
    case .if:
      return true
    case .import:
      return true
    case .in:
      return true
    case .`init`:
      return true
    case .inout:
      return true
    case .internal:
      return true
    case .is:
      return true
    case .let:
      return true
    case .nil:
      return true
    case .operator:
      return true
    case .precedencegroup:
      return true
    case .private:
      return true
    case .protocol:
      return true
    case .public:
      return true
    case .repeat:
      return true
    case .rethrows:
      return true
    case .return:
      return true
    case .self:
      return true
    case .Self:
      return true
    case .static:
      return true
    case .struct:
      return true
    case .subscript:
      return true
    case .super:
      return true
    case .switch:
      return true
    case .throw:
      return true
    case .throws:
      return true
    case .true:
      return true
    case .try:
      return true
    case .typealias:
      return true
    case .var:
      return true
    case .where:
      return true
    case .while:
      return true
    default:
      return false
    }
  }
}

extension TokenKind {
  /// Returns `true` if the token is a Swift keyword.
  ///
  /// Keywords are reserved unconditionally for use by Swift and may not
  /// appear as identifiers in any position without being escaped. For example,
  /// `class`, `func`, or `import`.
  @_spi(Diagnostics) @_spi(Testing)
  public var isLexerClassifiedKeyword: Bool {
    switch self {
    case .keyword(let keyword):
      return keyword.isLexerClassified
    default:
      return false
    }
  }
}

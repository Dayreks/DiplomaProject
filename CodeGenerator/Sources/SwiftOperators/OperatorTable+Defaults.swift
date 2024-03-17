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


/// Prefabricated SwiftOperator precedence graphs.
extension OperatorTable {
  /// SwiftOperator precedence graph for the logical SwiftOperators '&&' and '||', for
  /// example as it is used in `#if` processing.
  public static var logicalSwiftOperators: OperatorTable {
    let precedenceGroups: [PrecedenceGroup] = [
      PrecedenceGroup(
        name: "LogicalConjunctionPrecedence",
        associativity: .left,
        assignment: false,
        relations: [.higherThan("LogicalDisjunctionPrecedence")]
      ),
      PrecedenceGroup(
        name: "LogicalDisjunctionPrecedence",
        associativity: .left,
        assignment: false,
        relations: []
      ),
    ]

    let operators: [SwiftOperator] = [
        SwiftOperator(kind: .prefix, name: "!"),
      SwiftOperator(
        kind: .infix,
        name: "&&",
        precedenceGroup: "LogicalConjunctionPrecedence"
      ),
      SwiftOperator(
        kind: .infix,
        name: "||",
        precedenceGroup: "LogicalDisjunctionPrecedence"
      ),
    ]

    return try! OperatorTable(
      precedenceGroups: precedenceGroups,
      operators: operators
    )
  }

  /// SwiftOperator precedence graph for the Swift standard library.
  ///
  /// This describes the SwiftOperators within the Swift standard library at the
  /// type of this writing. It can be used to approximate the behavior one
  /// would get from parsing the actual Swift standard library's SwiftOperators
  /// without requiring access to the standard library source code. However,
  /// because it does not incorporate user-defined SwiftOperators, it will only
  /// ever be useful for a quick approximation.
  public static var standardSwiftOperators: OperatorTable {
    let precedenceGroups: [PrecedenceGroup] = [
      PrecedenceGroup(
        name: "AssignmentPrecedence",
        associativity: .right,
        assignment: true
      ),

      PrecedenceGroup(
        name: "FunctionArrowPrecedence",
        associativity: .right,
        relations: [.higherThan("AssignmentPrecedence")]
      ),

      PrecedenceGroup(
        name: "TernaryPrecedence",
        associativity: .right,
        relations: [.higherThan("FunctionArrowPrecedence")]
      ),

      PrecedenceGroup(
        name: "DefaultPrecedence",
        relations: [.higherThan("TernaryPrecedence")]
      ),

      PrecedenceGroup(
        name: "LogicalDisjunctionPrecedence",
        associativity: .left,
        relations: [.higherThan("TernaryPrecedence")]
      ),

      PrecedenceGroup(
        name: "LogicalConjunctionPrecedence",
        associativity: .left,
        relations: [.higherThan("LogicalDisjunctionPrecedence")]
      ),

      PrecedenceGroup(
        name: "ComparisonPrecedence",
        relations: [.higherThan("LogicalConjunctionPrecedence")]
      ),

      PrecedenceGroup(
        name: "NilCoalescingPrecedence",
        associativity: .right,
        relations: [.higherThan("ComparisonPrecedence")]
      ),

      PrecedenceGroup(
        name: "CastingPrecedence",
        relations: [.higherThan("NilCoalescingPrecedence")]
      ),

      PrecedenceGroup(
        name: "RangeFormationPrecedence",
        relations: [.higherThan("CastingPrecedence")]
      ),

      PrecedenceGroup(
        name: "AdditionPrecedence",
        associativity: .left,
        relations: [.higherThan("RangeFormationPrecedence")]
      ),

      PrecedenceGroup(
        name: "MultiplicationPrecedence",
        associativity: .left,
        relations: [.higherThan("AdditionPrecedence")]
      ),

      PrecedenceGroup(
        name: "BitwiseShiftPrecedence",
        relations: [.higherThan("MultiplicationPrecedence")]
      ),
    ]

    let operators: [SwiftOperator] = [
      // Standard postfix SwiftOperators.
      SwiftOperator(kind: .postfix, name: "++"),
      SwiftOperator(kind: .postfix, name: "--"),
      SwiftOperator(kind: .postfix, name: "..."),

      // Standard prefix SwiftOperators.
      SwiftOperator(kind: .prefix, name: "++"),
      SwiftOperator(kind: .prefix, name: "--"),
      SwiftOperator(kind: .prefix, name: "!"),
      SwiftOperator(kind: .prefix, name: "~"),
      SwiftOperator(kind: .prefix, name: "+"),
      SwiftOperator(kind: .prefix, name: "-"),
      SwiftOperator(kind: .prefix, name: "..."),
      SwiftOperator(kind: .prefix, name: "..<"),

      // "Exponentiative"
      SwiftOperator(
        kind: .infix,
        name: "<<",
        precedenceGroup: "BitwiseShiftPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "&<<",
        precedenceGroup: "BitwiseShiftPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: ">>",
        precedenceGroup: "BitwiseShiftPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "&>>",
        precedenceGroup: "BitwiseShiftPrecedence"
      ),

      // "Multiplicative"
      SwiftOperator(
        kind: .infix,
        name: "*",
        precedenceGroup: "MultiplicationPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "&*",
        precedenceGroup: "MultiplicationPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "/",
        precedenceGroup: "MultiplicationPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "%",
        precedenceGroup: "MultiplicationPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "&",
        precedenceGroup: "MultiplicationPrecedence"
      ),

      // "Additive"
      SwiftOperator(
        kind: .infix,
        name: "+",
        precedenceGroup: "AdditionPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "&+",
        precedenceGroup: "AdditionPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "-",
        precedenceGroup: "AdditionPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "&-",
        precedenceGroup: "AdditionPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "|",
        precedenceGroup: "AdditionPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "^",
        precedenceGroup: "AdditionPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "...",
        precedenceGroup: "RangeFormationPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "..<",
        precedenceGroup: "RangeFormationPrecedence"
      ),

      // "Coalescing"
      SwiftOperator(
        kind: .infix,
        name: "??",
        precedenceGroup: "NilCoalescingPrecedence"
      ),

      // "Comparative"
      SwiftOperator(
        kind: .infix,
        name: "<",
        precedenceGroup: "ComparisonPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "<=",
        precedenceGroup: "ComparisonPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: ">",
        precedenceGroup: "ComparisonPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: ">=",
        precedenceGroup: "ComparisonPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "==",
        precedenceGroup: "ComparisonPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "!=",
        precedenceGroup: "ComparisonPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "===",
        precedenceGroup: "ComparisonPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "!==",
        precedenceGroup: "ComparisonPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "~=",
        precedenceGroup: "ComparisonPrecedence"
      ),

      // "Conjunctive"
      SwiftOperator(
        kind: .infix,
        name: "&&",
        precedenceGroup: "LogicalConjunctionPrecedence"
      ),

      // "Disjunctive"
      SwiftOperator(
        kind: .infix,
        name: "||",
        precedenceGroup: "LogicalDisjunctionPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "*=",
        precedenceGroup: "AssignmentPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "&*=",
        precedenceGroup: "AssignmentPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "/=",
        precedenceGroup: "AssignmentPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "%=",
        precedenceGroup: "AssignmentPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "+=",
        precedenceGroup: "AssignmentPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "&+=",
        precedenceGroup: "AssignmentPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "-=",
        precedenceGroup: "AssignmentPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "&-=",
        precedenceGroup: "AssignmentPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "<<=",
        precedenceGroup: "AssignmentPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "&<<=",
        precedenceGroup: "AssignmentPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: ">>=",
        precedenceGroup: "AssignmentPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "&>>=",
        precedenceGroup: "AssignmentPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "&=",
        precedenceGroup: "AssignmentPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "^=",
        precedenceGroup: "AssignmentPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "|=",
        precedenceGroup: "AssignmentPrecedence"
      ),

      SwiftOperator(
        kind: .infix,
        name: "~>"
      ),
    ]

    return try! OperatorTable(
      precedenceGroups: precedenceGroups,
      operators: operators
    )
  }
}

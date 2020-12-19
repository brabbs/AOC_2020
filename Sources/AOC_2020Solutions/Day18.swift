//
//  DayTemplate.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation

struct Day18: Solution {
    let expressions: [Expression]

    init(input: String) {
        expressions = time {
            input
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: "\n")
                .map(Expression.init(rawString:))
        }
    }

    func first() -> Any {
        time {
            expressions.lazy
                .map { $0.evaluate() }
                .sum()
        }
    }

    func second() -> Any {
        "Second answer not yet implemented"
    }
}

extension Day18 {
    indirect enum Expression: CustomStringConvertible {
        case add(Expression, Expression)
        case multiply(Expression, Expression)
        case value(Int)

        var description: String {
            switch self {
            case .add(let left, let right): return "(\(left))+(\(right))"
            case .multiply(let left, let right): return "(\(left))*(\(right))"
            case .value(let number): return String(number)
            }
        }

        init(rawString: String) {
            let expressionString = Self.removingSurroundingBrackets(
                in: rawString.trimmingCharacters(in: .whitespaces)
            )

            if let index = Self.lastTopLevelOperatorIndex(in: expressionString) {
                let left = String(expressionString[..<index])
                let nextIndex = expressionString.index(after: index)
                let right = String(expressionString[nextIndex...])

                if expressionString[index] == "+" {
                    self = .add(Expression(rawString: left), Expression(rawString: right))
                } else {
                    self = .multiply(Expression(rawString: left), Expression(rawString: right))
                }

                return
            }

            self = .value(Int(expressionString)!)
        }

        /// Last operator not contained in brackets. This should be the last operation to be performed
        static func lastTopLevelOperatorIndex(
            in expressionString: String
        ) -> (String.Index)? {
            var bracketCount = 0

            for index in expressionString.indices.reversed() {
                let char = expressionString[index]

                if char == "(" {
                    bracketCount += 1
                } else if char == ")" {
                    bracketCount -= 1
                } else if (char == "+" || char == "*") && bracketCount == 0 {
                    return index
                }
            }

            return nil
        }

        static func removingSurroundingBrackets(in expressionString: String) -> String {
            var bracketCount = 0

            guard expressionString.count > 1 else {
                return expressionString
            }

            for character in expressionString.dropLast() {
                if character == "(" {
                    bracketCount += 1
                } else if character == ")" {
                    bracketCount -= 1
                }

                if bracketCount == 0 {
                    // No surrounding brackets
                    return expressionString
                }
            }

            var trimmedString = expressionString
            trimmedString.removeFirst()
            trimmedString.removeLast()
            return trimmedString
        }

        func evaluate() -> Int {
            switch self {
            case .add(let left, let right): return left.evaluate() + right.evaluate()
            case .multiply(let left, let right): return left.evaluate() * right.evaluate()
            case .value(let number): return number
            }
        }
    }
}

//
//  DayTemplate.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation

struct Day18: Solution {
    let expressionStrings: [String]

    init(input: String) {
        expressionStrings = time {
            input
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: "\n")
        }
    }

    func first() -> Any {
        time {
            expressionStrings.lazy
                .map { Expression(rawString: $0, additionFirst: false) }
                .map { $0.evaluate() }
                .sum()
        }
    }

    func second() -> Any {
        time {
            expressionStrings.lazy
                .map { Expression(rawString: $0, additionFirst: true) }
                .map { $0.evaluate() }
                .sum()
        }
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

        init(rawString: String, additionFirst: Bool) {
            let expressionString = Self.removingSurroundingBrackets(
                in: rawString.trimmingCharacters(in: .whitespaces)
            )

            if let index = Self.lastTopLevelOperatorIndex(
                in: expressionString,
                additionFirst: additionFirst
            ) {
                let leftString = String(expressionString[..<index])
                let left = Expression(rawString: leftString, additionFirst: additionFirst)

                let nextIndex = expressionString.index(after: index)
                let rightString = String(expressionString[nextIndex...])
                let right = Expression(rawString: rightString, additionFirst: additionFirst)

                if expressionString[index] == "+" {
                    self = .add(left, right)
                } else {
                    self = .multiply(left, right)
                }

                return
            }

            self = .value(Int(expressionString)!)
        }

        /// Last operator not contained in brackets. This should be the last operation to be performed.
        static func lastTopLevelOperatorIndex(
            in expressionString: String,
            additionFirst: Bool
        ) -> (String.Index)? {
            var bracketCount = 0

            var additionIndex: String.Index?
            for index in expressionString.indices.reversed() {
                let char = expressionString[index]

                if char == "(" {
                    bracketCount += 1
                } else if char == ")" {
                    bracketCount -= 1
                } else if char == "+" && bracketCount == 0 {
                    if additionFirst && additionIndex == nil {
                        // Only use this addition if we don't find and multiplication
                        additionIndex = index
                    } else if !additionFirst {
                        return index
                    }
                } else if char == "*" && bracketCount == 0 {
                    return index
                }
            }

            return additionIndex
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

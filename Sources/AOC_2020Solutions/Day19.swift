//
//  DayTemplate.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation
import Regex

struct Day19: Solution {
    let ruleDescriptions: [Int: String]
    let messages: [String]
    

    init(input: String) {
        let parts = input.components(separatedBy: "\n\n")

        let lines = parts[0]
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "\n")
        ruleDescriptions = lines.reduce(into: [Int: String]()) { ruleDescriptions, line in
            guard let colonIndex = line.firstIndex(of: ":") else { return }
            guard let ruleNumber = Int(line[..<colonIndex]) else { return }
            // Drop colon and space
            let descrition = String(line[colonIndex...].dropFirst(2))
            ruleDescriptions[ruleNumber] = descrition
        }

        messages = parts[1]
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "\n")
    }

    func first() -> Any {
        let ruleFactory = RuleFactory(ruleDescriptions: ruleDescriptions)
        let ruleZero = ruleFactory.rule(0)
        return messages.count(where: ruleZero.matchesExactly)
    }

    func second() -> Any {
        "Second answer not yet implemented"
    }
}

extension Day19 {
    class RuleFactory {
        let ruleDescriptions: [Int: String]
        private(set) var rules = [Int: Rule]()

        init(ruleDescriptions: [Int: String]) {
            self.ruleDescriptions = ruleDescriptions
        }

        func rule(_ number: Int) -> Rule {
            if let ruleFromCache = rules[number] {
                return ruleFromCache
            } else if let description = ruleDescriptions[number] {
                let newRule = getRule(from: description)
                rules[number] = newRule
                return newRule
            }

            fatalError("No rule \(number)")
        }

        func getRule(from description: String) -> Rule {
            if let singleNumberRule = getSingleNumberRule(from: description) {
                return singleNumberRule
            } else if let letterRule = getLetterRule(from: description) {
                return letterRule
            } else if let disjunctionRule = getDisjunctionRule(from: description) {
                return disjunctionRule
            } else if let conjunctionRule = getConjunctionRule(from: description) {
                return conjunctionRule
            }

            fatalError("Badly formed description \(description)")
        }

        func getSingleNumberRule(from description: String) -> Rule? {
            guard let number = Int(description) else { return nil }
            return rule(number)
        }

        static let letterRegex = Regex(#"^"([a-z])"$"#)
        func getLetterRule(from description: String) -> Rule? {
            guard
                let match = Self.letterRegex.firstMatch(in: description),
                let character = match.captures[0]?.first
            else {
                return nil
            }

            return .letter(character)
        }

        func getDisjunctionRule(from description: String) -> Rule? {
            guard let separatorIndex = description.firstIndex(of: "|") else { return nil }

            let first = description[..<separatorIndex]
                .trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
            let second = description[separatorIndex...]
                .trimmingCharacters(in: CharacterSet.decimalDigits.inverted)

            return getRule(from: first) | getRule(from: second)
        }

        func getConjunctionRule(from description: String) -> Rule? {
            let optionalNumbers = description
                .components(separatedBy: " ")
                .map { Int($0) }

            guard optionalNumbers.allSatisfy({ $0 != nil }) else {
                return nil
            }

            let rules = optionalNumbers
                .compactMap { $0 }
                .map(rule(_:))

            return .consecutive(rules)
        }
    }
}

infix operator >>: AdditionPrecedence
extension Day19 {
    struct Rule {
        let parser: (Substring) -> String.Index?

        func matchesExactly(_ input: String) -> Bool {
            parser(Substring(input)) == input.endIndex
        }

        static let trivial = Rule { $0.startIndex }

        static func letter(_ letter: Character) -> Rule {
            Rule { (input: Substring) -> String.Index? in
                guard let first = input.first else { return nil }
                return first == letter ? input.index(after: input.startIndex) : nil
            }
        }

        static func |(lhs: Rule, rhs: Rule) -> Rule {
            Rule { (input: Substring) -> String.Index? in
                if let leftMatch = lhs.parser(input) {
                    return leftMatch
                } else if let rightMatch = rhs.parser(input) {
                    return rightMatch
                } else {
                    return nil
                }
            }
        }

        static func >>(lhs: Rule, rhs: Rule) -> Rule {
            Rule { (input: Substring) -> String.Index? in
                guard let firstMatch = lhs.parser(input) else { return nil }
                return rhs.parser(input[firstMatch...])
            }
        }

        static func consecutive(_ rules: [Rule]) -> Rule {
            rules.reduce(.trivial, >>)
        }
    }
}

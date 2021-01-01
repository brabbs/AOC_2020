//
//  DayTemplate.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation
import Regex

struct Day19: Solution {
    let initialRuleDirectory: [Int: Rule]
    let messages: [String]

    init(input: String) {
        let parts = input.components(separatedBy: "\n\n")

        let lines = parts[0]
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "\n")
        initialRuleDirectory = lines.reduce(into: [Int: Rule]()) { ruleDescriptions, line in
            guard let colonIndex = line.firstIndex(of: ":") else { return }
            guard let ruleNumber = Int(line[..<colonIndex]) else { return }
            // Drop colon and space
            let description = String(line[colonIndex...].dropFirst(2))
            ruleDescriptions[ruleNumber] = Rule(rawValue: description)
        }

        messages = parts[1]
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "\n")
    }

    func first() -> Any {
        guard let ruleZero = initialRuleDirectory[0] else { return "No rule zero" }
        let ruleComputer = RuleComputer(topRule: ruleZero, ruleDirectory: initialRuleDirectory)
        return messages.count(where: ruleComputer.isMatch)
    }

    func second() -> Any {
        var ruleDirectory = initialRuleDirectory
        ruleDirectory[8] = .or([42], [42, 8])
        ruleDirectory[11] = .or([42, 31], [42, 11, 31])

        guard let ruleZero = ruleDirectory[0] else { return "No rule zero" }
        let ruleComputer = RuleComputer(topRule: ruleZero, ruleDirectory: ruleDirectory)
        return messages.count(where: ruleComputer.isMatch)
    }
}

extension Day19 {
    struct RuleComputer {
        let topRule: Rule
        let ruleDirectory: [Int: Rule]

        func isMatch(_ input: String) -> Bool {
            // Matches input if after matching we've consumed the whole string
            matches(input[...], against: topRule).contains("")
        }

        private func matches(_ input: Substring, against rule: Rule) -> [Substring] {
            switch rule {
            case let .letter(letter):
                return input.first == letter ? [input.dropFirst()] : []
            case let .consecutive(rules):
                return matches(input, againstConsecutive: rules)
            case let .or(firstRules, secondRules):
                return [firstRules, secondRules].flatMap { ruleNumbers in
                    matches(input, againstConsecutive: ruleNumbers)
                }
            }
        }

        private func matches(_ input: Substring, againstConsecutive rules: [Int]) -> [Substring] {
            var result = [input]
            for ruleNumber in rules {
                guard let nextRule = ruleDirectory[ruleNumber] else { return [] }
                result = result.flatMap { input in matches(input, against: nextRule) }
            }
            return result
        }
    }
}

extension Day19 {
    enum Rule {
        case letter(Character)
        case consecutive([Int])
        case or([Int], [Int])

        static let letterRegex = Regex(#"^"([a-z])"$"#)
        static let consecutiveRegex = Regex(#"^((?:\d+ ?)+)$"#)
        static let orRegex = Regex(#"^((?:\d+ ?)+)\| ((?:\d+ ?)+)$"#)
        init?(rawValue: String) {
            if let captures = Self.letterRegex.firstMatch(in: rawValue)?.captures {
                guard let character = captures[0]?.first else { return nil }
                self = .letter(character)
            } else if let captures = Self.consecutiveRegex.firstMatch(in: rawValue)?.captures {
                guard let numbersString = captures[0] else { return nil }
                let numbers = Self.numberList(from: numbersString)
                self = .consecutive(numbers)
            } else if let captures = Self.orRegex.firstMatch(in: rawValue)?.captures {
                guard let first = captures[0] else { return nil }
                guard let second = captures[1] else { return nil }
                self = .or(
                    Self.numberList(from: first),
                    Self.numberList(from: second)
                )
            } else {
                // Doesn't match any of the regexes
                return nil
            }
        }

        static func numberList(from rawString: String) -> [Int] {
            return rawString.split(separator: " ").compactMap { Int($0) }
        }
    }
}

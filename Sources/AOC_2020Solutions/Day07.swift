//
//  Day07.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation
import Regex

struct Day07: Solution {
    let bagRules: [BagRule]
    let myBagName = "shiny gold"

    init(input: String) {
        bagRules = input
            .components(separatedBy: "\n")
            .compactMap(BagRule.init(rawString:))
    }

    func first() -> Any {
        let canBeContainedGraph = getCanBeContainedGraph()
        var toBeVisited: [String] = [myBagName]
        var visited: [String] = []

        while let currentBag = toBeVisited.popLast() {
            let neighbours = canBeContainedGraph[currentBag] ?? []
            let unseenNeighbours = neighbours.filter {
                !visited.contains($0) && !toBeVisited.contains($0)
            }
            toBeVisited.append(contentsOf: unseenNeighbours)
            visited.append(currentBag)
        }

        // Return number of bags in connected component of "shiny gold"
        // not including "shiny gold" itself
        return visited.count - 1
    }

    func getCanBeContainedGraph() -> [String: [String]] {
        var canBeContainedGraph = [String: [String]]()
        for bagRule in bagRules {
            for containedBag in bagRule.containedBags {
                let bagName = containedBag.bagName
                if let currentlyCanBeContained = canBeContainedGraph[bagName] {
                    canBeContainedGraph[bagName] = currentlyCanBeContained + [bagRule.bagName]
                } else {
                    canBeContainedGraph[bagName] = [bagRule.bagName]
                }
            }
        }
        return canBeContainedGraph
    }

    func second() throws -> Any {
        // Keys are bag names. Values are the number of bags they contain.
        var bagValues = [String: Int]()
        var toCalculate = [myBagName]

        while let currentBag = toCalculate.last {
            if bagValues.keys.contains(currentBag) {
                // Already done this one
                toCalculate.removeLast()
                continue
            }

            let currentBagRule = try getBagRule(for: currentBag)
            if currentBagRule.containedBags.contains(where: {
                !bagValues.keys.contains($0.bagName)
            }) {
                // Need to calculate a contained bag first
                let uncalculatedBagNames = currentBagRule
                    .containedBags
                    .filter { !bagValues.keys.contains($0.bagName) }
                    .map(\.bagName)
                toCalculate.append(contentsOf: uncalculatedBagNames)
            } else {
                // Have all the info to calculate this bag
                let value = currentBagRule
                    .containedBags
                    .compactMap { containedBag -> Int? in
                        // bagValue should never be nil here
                        guard let bagValue = bagValues[containedBag.bagName] else { return nil }
                        return containedBag.quantity * (1 + bagValue)
                    }
                    .sum()
                bagValues[currentBag] = value
                toCalculate.removeLast()
            }
        }

        return bagValues[myBagName] ?? -1
    }

    func getBagRule(for bagName: String) throws -> BagRule {
        guard let bagRule = bagRules.first(where: { $0.bagName == bagName }) else {
            throw Day07Error.noBagRuleForBagName(bagName)
        }
        return bagRule
    }
}

extension Day07 {
    struct BagRule {
        let bagName: String
        let containedBags: [ContainedBagCondition]

        static let regex = Regex(#"(\w+ \w+) bags contain (.*)"#)
        static let containNoBagsCondition = "contain no other bags."

        init?(rawString: String) {
            guard
                let captures = Self.regex.firstMatch(in: rawString)?.captures,
                let bagName = captures[0],
                let containedCondition = captures[1]
            else {
                return nil
            }

            self.bagName = bagName

            if containedCondition == Self.containNoBagsCondition {
                containedBags = []
            } else {
                containedBags = containedCondition
                    .components(separatedBy: ",")
                    .compactMap(ContainedBagCondition.init(rawString:))
            }
        }
    }
}

extension Day07.BagRule {
    struct ContainedBagCondition {
        let bagName: String
        let quantity: Int

        static let regex = Regex(#"(\d+) (\w+ \w+) bags?\.?"#)

        init?(rawString: String) {
            guard
                let captures = Self.regex.firstMatch(in: rawString)?.captures,
                let quantity = captures[0].flatMap(Int.init),
                let bagName = captures[1]
            else {
                return nil
            }

            self.quantity = quantity
            self.bagName = bagName
        }
    }
}

extension Day07 {
    enum Day07Error: Error {
        case noBagRuleForBagName(String)
    }
}

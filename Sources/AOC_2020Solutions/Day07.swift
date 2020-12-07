//
//  Day07.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation
import Regex

struct Day07: Solution {
    let bagRules: [BagRule]

    init(input: String) {
        let fakeInput = """
        light red bags contain 1 bright white bag, 2 muted yellow bags.
        dark orange bags contain 3 bright white bags, 4 muted yellow bags.
        bright white bags contain 1 shiny gold bag.
        muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
        shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
        dark olive bags contain 3 faded blue bags, 4 dotted black bags.
        vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
        faded blue bags contain no other bags.
        dotted black bags contain no other bags.
        """
        bagRules = input
            .components(separatedBy: "\n")
            .compactMap(BagRule.init(rawString:))
    }

    func first() -> Any {
        let canBeContainedGraph = getCanBeContainedGraph()
        var toBeVisited: [String] = ["shiny gold"]
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

    func second() -> Any {
        "Second answer not yet implemented"
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

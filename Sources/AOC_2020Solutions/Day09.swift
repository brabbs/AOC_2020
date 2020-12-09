//
//  Day09.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation

struct Day09: Solution {
    let cypher: [Int]

    init(input: String) {
        cypher = input
            .split(separator: "\n")
            .compactMap { Int($0) }
    }

    func first() -> Any {
        for i in 25..<cypher.count {
            let previous = SortedArray(cypher[0..<i])
            let current = cypher[i]
            if previous.pairSumming(to: current) == nil {
                // Invalid number
                return current
            }
        }
        return "All numbers are valid"
    }

    func second() -> Any {
        "Second answer not yet implemented"
    }
}

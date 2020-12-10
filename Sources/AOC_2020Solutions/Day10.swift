//
//  Day10.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation

struct Day10: Solution {
    let adaptors: [Int]

    init(input: String) {
        adaptors = input
            .split(separator: "\n")
            .compactMap { Int($0) }
    }

    func first() -> Any {
        let outlet = 0
        let device = (adaptors.max() ?? 0) + 3
        let sortedAdaptors = (adaptors + [outlet, device]).sorted()
        let consecutivePairs = zip(
            sortedAdaptors[..<(sortedAdaptors.endIndex - 1)],
            sortedAdaptors[1..<sortedAdaptors.endIndex])
        let differences = consecutivePairs.reduce(into: [Int: Int]()) { differences, pair in
            let difference = pair.1 - pair.0
            differences[difference, default: 0] += 1
        }

        return (differences[1] ?? 0) * (differences[3] ?? 0)
    }

    func second() -> Any {
        "Second answer not yet implemented"
    }
}

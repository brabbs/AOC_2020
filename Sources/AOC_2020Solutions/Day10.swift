//
//  Day10.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation

struct Day10: Solution {
    let joltages: [Int]

    init(input: String) {
        let adaptorsInBag = input
            .split(separator: "\n")
            .compactMap { Int($0) }
        let outlet = 0
        let device = (adaptorsInBag.max() ?? 0) + 3
        joltages = adaptorsInBag + [outlet, device]
    }

    func first() -> Any {
        let sortedJoltages = joltages.sorted()
        let consecutivePairs = zip(
            sortedJoltages[..<(sortedJoltages.endIndex - 1)],
            sortedJoltages[1..<sortedJoltages.endIndex])
        let differences = consecutivePairs.reduce(into: [Int: Int]()) { differences, pair in
            let difference = pair.1 - pair.0
            differences[difference, default: 0] += 1
        }

        return (differences[1] ?? 0) * (differences[3] ?? 0)
    }

    func second() -> Any {
        let sortedJoltages = joltages.sorted().reversed()
        let device = sortedJoltages.first ?? 0
        let paths = sortedJoltages.dropFirst().reduce(into: [device: 1]) { paths, joltage in
            let reachable = joltages.filter { 0 < $0 - joltage && $0 - joltage <= 3 }
            let pathsFromJoltage = reachable.compactMap { paths[$0] }.sum()
            paths[joltage] = pathsFromJoltage
        }

        return paths[0] ?? -1
    }
}

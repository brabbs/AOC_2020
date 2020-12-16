//
//  Day15.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation

struct Day15: Solution {
    let starting: [Int]

    init(input: String) {
        starting = input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: ",")
            .compactMap { Int($0) }
    }

    func first() -> Any {
        time { gameNumber(at: 2020) }
    }

    func second() -> Any {
        time { gameNumber(at: 30_000_000) }
    }

    func gameNumber(at finalIndex: Int) -> Int {
        var lastNumber =  starting.last!

        // Add one to indices as game starts at 1 rather than 0
        var lastIndices = lastIndexDictionary(for: starting.dropLast())
            .mapValues { $0 + 1 }

        for index in starting.endIndex..<finalIndex {
            let nextNumber: Int
            if let lastIndex = lastIndices[lastNumber] {
                nextNumber = index - lastIndex
            } else {
                nextNumber = 0
            }

            lastIndices[lastNumber] = index
            lastNumber = nextNumber
        }

        return lastNumber
    }

    func lastIndexDictionary(for array: [Int]) -> [Int: Int] {
        array.enumerated().reduce(into: [Int: Int]()) { result, contents in
            let (index, value) = contents
            result[value] = index
        }
    }
}

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
        let limit = 2020 - starting.count
        let game = time {
            stride(from: 0, to: limit, by: 1).reduce(into: starting) { game, _ in
                guard let last = game.last else { return }
                if let indexOfLastOccurrence = game.dropLast().lastIndex(of: last) {
                    let nextNumber = (game.endIndex - 1) - indexOfLastOccurrence
                    game.append(nextNumber)
                } else {
                    game.append(0)
                }
            }
        }
        return game[2019]
    }

    func second() -> Any {
        "Second answer not yet implemented"
    }
}

//
//  Day13.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation

struct Day13: Solution {
    let earliestDeparture: Int
    let busIds: [Int]

    init(input: String) {
        let parts = input.split(separator: "\n")
        earliestDeparture = Int(parts[0]) ?? 0
        busIds = parts[1].split(separator: ",").compactMap { Int($0) }
    }

    func first() -> Any {
        guard let firstBusAndWait = getFirstBusAndWait() else {
            return "No Bus IDs"
        }

        return firstBusAndWait.0 * firstBusAndWait.1
    }

    func getFirstBusAndWait() -> (Int, Int)? {
        busIds
            .lazy
            // Calculate minutes after earliest departure of each bus
            .map { ($0, $0 - (earliestDeparture % $0)) }
            .min { $0.1 <= $1.1 }
    }

    func second() -> Any {
        "Second answer not yet implemented"
    }
}

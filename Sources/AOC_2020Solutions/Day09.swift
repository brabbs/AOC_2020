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
        let range = contiguousRange(summingTo: 530627549)
        guard
            let smallest = range?.min(),
            let largest = range?.max()
        else {
            return "No range found"
        }

        return smallest + largest
    }

    func contiguousRange(summingTo goal: Int) -> [Int]? {
        var lowIndex = cypher.startIndex
        var highIndex = cypher.startIndex
        var runningSum = 0

        while highIndex < cypher.endIndex ||
                (highIndex == cypher.endIndex && runningSum >= goal) {
            if runningSum == goal {
                return Array(cypher[lowIndex..<highIndex])
            } else if runningSum < goal {
                // Sum is too low, need to add the next number along
                runningSum += cypher[highIndex]
                highIndex += 1
            } else if runningSum > goal {
                // Sum is too high, need to remove the earliest number
                runningSum -= cypher[lowIndex]
                lowIndex += 1
            }
        }

        // Ran through whole array and didn't find a range summing to the goal
        return nil
    }
}

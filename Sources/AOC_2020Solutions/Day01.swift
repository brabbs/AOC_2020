//
//  Day01.swift
//  
//  Solution to day 01 of Advent of Code 2020

import Foundation

struct Day01: Solution {
    let expenses: [Int]

    init(input: String) {
        expenses = input
            .split(separator: "\n")
            .compactMap { Int($0) }
            .sorted()
    }

    func first() -> Any {
        var sum = 0
        // Start with the highest number and the lowest number
        var lowIndex = expenses.startIndex
        var highIndex = expenses.endIndex - 1

        let goal = 2020
        while (sum != goal) {
            sum = expenses[lowIndex] + expenses[highIndex]
            print("Total: \(sum), \(lowIndex):\(highIndex)")
            if sum < goal {
                // Sum is too low, increase the lower number
                lowIndex += 1
            } else if sum > goal {
                // Sum is too high, decrease the higher number
                highIndex -= 1
            }

            if lowIndex == highIndex {
                // We've met in the middle and not found an exact solution
                return "No solution found"
            }
        }

        return expenses[lowIndex] * expenses[highIndex]
    }

    func second() -> Any {
        "Second answer not yet implemented"
    }
}

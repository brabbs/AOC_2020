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
        if let (expense1, expense2) = findPair(summingTo: 2020) {
            return expense1 * expense2
        } else {
            return "Unable to find pair that sums exactly to 2020"
        }
    }

    func second() -> Any {
        for expense in expenses {
            if let (expense1, expense2) = findPair(summingTo: 2020 - expense) {
                // Sum should be 2020
                let sum = expense + expense1 + expense2
                print("Triple summing to \(sum) is \(expense), \(expense1), \(expense2)")
                return expense * expense1 * expense2
            }
        }

        return "Unable to find a triple summing to 2020"
    }

    func findPair(summingTo goal: Int) -> (Int, Int)? {
        var sum = 0
        // Start with the highest number and the lowest number
        var lowIndex = expenses.startIndex
        var highIndex = expenses.endIndex - 1

        while (sum != goal) {
            sum = expenses[lowIndex] + expenses[highIndex]
            if sum < goal {
                // Sum is too low, increase the lower number
                lowIndex += 1
            } else if sum > goal {
                // Sum is too high, decrease the higher number
                highIndex -= 1
            }

            if lowIndex == highIndex {
                // We've met in the middle and not found an exact solution
                return nil
            }
        }

        return (expenses[lowIndex], expenses[highIndex])
    }
}

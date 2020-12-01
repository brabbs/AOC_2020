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
        if let (expense1, expense2, expense3) = time({ findTriple(summingTo: 2020) }) {
            return expense1 * expense2 * expense3
        } else {
            return "Unable to find a triple summing to 2020"
        }
    }

    func findTriple(summingTo goal: Int) -> (Int, Int, Int)? {
        for (index, expense) in expenses.enumerated() {
            if let (expense1, expense2) = findPair(
                summingTo: goal - expense,
                withoutIndex: index
            ) {
                // Sum should be 2020
                let sum = expense + expense1 + expense2
                print("Triple summing to \(sum) is \(expense), \(expense1), \(expense2)")
                return (expense, expense1, expense2)
            }
        }

        return nil
    }

    func findPair(
        summingTo goal: Int,
        withoutIndex indexToIgnore: Array<Int>.Index? = nil
    ) -> (Int, Int)? {
        let expensesToSearch = getExpenses(withoutIndex: indexToIgnore)
        var sum = 0
        // Start with the highest number and the lowest number
        var lowIndex = expensesToSearch.startIndex
        var highIndex = expensesToSearch.index(before: expensesToSearch.endIndex)

        while (sum != goal) {
            sum = expensesToSearch[lowIndex] + expensesToSearch[highIndex]
            if sum < goal {
                // Sum is too low, increase the lower number
                lowIndex = expensesToSearch.index(after: lowIndex)
            } else if sum > goal {
                // Sum is too high, decrease the higher number
                highIndex = expensesToSearch.index(before: highIndex)
            }

            if lowIndex == highIndex {
                // We've met in the middle and not found an exact solution
                return nil
            }
        }

        return (expensesToSearch[lowIndex], expensesToSearch[highIndex])
    }

    func getExpenses(withoutIndex indexToIgnore: Array<Int>.Index? = nil) -> [Int] {
        if let indexToIgnore = indexToIgnore {
            var result = expenses
            result.remove(at: indexToIgnore)
            return result
        } else {
            return expenses
        }
    }
}

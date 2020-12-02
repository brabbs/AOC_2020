//
//  DayTemplate.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation

struct Day02: Solution {
    let passwords: [PasswordEntry]

    init(input: String) {
        self.passwords = input
            .split(separator: "\n")
            .map(String.init)
            .map(PasswordEntry.init(databaseEntry:))
    }

    func first() -> Any {
        time { passwords.count { $0.isValidPartOne() } }
    }

    func second() -> Any {
        time { passwords.count { $0.isValidPartTwo() } }
    }
}

extension Day02 {
    struct PasswordEntry {
        // In part 1 the numbers are the min and max. In part 2 they are indicies.
        let firstNumber: Int
        let secondNumber: Int

        let requiredLetter: Character
        let password: String

        init(databaseEntry: String) {
            let parts = databaseEntry.split(separator: " ")

            // First part should look like: "1-3"
            let numbers = parts[0].split(separator: "-").compactMap { Int($0) }
            firstNumber = numbers[0]
            secondNumber = numbers[1]

            // Next we get something like "b:"
            requiredLetter = parts[1].first!

            // Finally we get the password
            password = String(parts[2])
        }

        func isValidPartOne() -> Bool {
            let occurances = password.count(of: requiredLetter)
            return firstNumber <= occurances && occurances <= secondNumber
        }

        func isValidPartTwo() -> Bool {
            let firstIndex = password.index(password.startIndex, offsetBy: firstNumber - 1)
            let secondIndex = password.index(password.startIndex, offsetBy: secondNumber - 1)
            let firstLetter = password[firstIndex]
            let secondLetter = password[secondIndex]

            return (firstLetter == requiredLetter && secondLetter != requiredLetter)
                || (firstLetter != requiredLetter && secondLetter == requiredLetter)
        }
    }
}

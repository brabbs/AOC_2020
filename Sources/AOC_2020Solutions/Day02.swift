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
        time { passwords.count { $0.isValid() } }
    }

    func second() -> Any {
        "Second answer not yet implemented"
    }
}

extension Day02 {
    struct PasswordEntry {
        let minOccurences: Int
        let maxOccurences: Int
        let requiredLetter: Character
        let password: String

        init(databaseEntry: String) {
            let parts = databaseEntry.split(separator: " ")

            // First part should look like: "1-3"
            let occuranceLimits = parts[0].split(separator: "-").compactMap { Int($0) }
            minOccurences = occuranceLimits[0]
            maxOccurences = occuranceLimits[1]

            // Next we get something like "b:"
            requiredLetter = parts[1].first!

            // Finally we get the password
            password = String(parts[2])
        }

        func isValid() -> Bool {
            let occurances = password.count(of: requiredLetter)
            return minOccurences <= occurances && occurances <= maxOccurences
        }
    }
}

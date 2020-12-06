//
//  Day06.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation

struct Day06: Solution {
    let groups: [Group]

    init(input: String) {
        groups = input
            .components(separatedBy: "\n\n")
            .map(Group.init(rawString:))
    }

    func first() -> Any {
        groups.lazy
            .map(\.yesCount)
            .reduce(0, +)
    }

    func second() -> Any {
        "Second answer not yet implemented"
    }
}

extension Day06 {
    struct Group {
        let yesAnswers: Set<Unicode.Scalar>
        var yesCount: Int { yesAnswers.count }


        init(rawString: String) {
            yesAnswers = rawString.unicodeScalars.reduce(
                into: Set<Unicode.Scalar>()
            ) { result, answer in
                if CharacterSet.lowercaseLetters.contains(answer) {
                    result.insert(answer)
                }
            }
        }
    }
}

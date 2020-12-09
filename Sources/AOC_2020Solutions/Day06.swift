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
            .map { $0.anyYesCount() }
            .sum()
    }

    func second() -> Any {
        groups.lazy
            .map { $0.allYesCount() }
            .sum()
    }
}

extension Day06 {
    struct Group {
        let people: [Person]

        init(rawString: String) {
            people = rawString
                .components(separatedBy: "\n")
                .map(Person.init(rawString:))
        }

        func anyYesCount() -> Int {
            people.reduce(into: Set<Unicode.Scalar>()) { result, person in
                result.formUnion(person.yesAnswers)
            }.count
        }

        func allYesCount() -> Int {
            guard let firstPerson = people.first else { return 0 }
            return people
                .dropFirst()
                .reduce(firstPerson.yesAnswers) { result, person in
                    result.intersection(person.yesAnswers)
                }
                .count
        }
    }
}

extension Day06.Group {
    struct Person {
        let yesAnswers: Set<Unicode.Scalar>
        init(rawString: String) {
            yesAnswers = Set(rawString.unicodeScalars)
        }
    }
}

//
//  Day16.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation
import Regex

struct Day16: Solution {
    let fields: [Field]
    let tickets: [Ticket]

    init(input: String) {
        let parts = input.components(separatedBy: "\n\n")
        fields = parts[0]
            .components(separatedBy: "\n")
            .compactMap(Field.init(rawString:))
        tickets = parts[2]
            .components(separatedBy: "\n")
            .filter { $0.contains(",") }
            .map(Ticket.init(rawString:))
    }

    func first() -> Any {
        let totalRange = fields
            .flatMap { [$0.lowRange, $0.highRange] }
            .joined()
        let invalidValues = tickets.lazy
            .flatMap(\.values)
            .filter { !totalRange.contains($0) }
        return invalidValues.sum()
    }

    func second() -> Any {
        "Second"
    }
}

extension Day16 {
    struct Field {
        let name: String
        let lowRange: ClosedRange<Int>
        let highRange: ClosedRange<Int>

        static let regex = Regex(#"^([\w ]+): ([\d\-]+) or ([\d\-]+)$"#)
        init?(rawString: String) {
            guard let captures = Self.regex.firstMatch(in: rawString)?.captures else { return nil }

            guard let name = captures[0] else { return nil }
            self.name = name

            guard let lowRange = captures[1].flatMap(Self.range(from:)) else { return nil }
            self.lowRange = lowRange

            guard let highRange = captures[2].flatMap(Self.range(from:)) else { return nil }
            self.highRange = highRange
        }

        static func range(from rawString: String) -> ClosedRange<Int>? {
            let bounds = rawString.split(separator: "-").compactMap { Int($0) }
            guard bounds.count == 2 else { return nil }
            return bounds[0]...bounds[1]
        }
    }
}

extension Day16 {
    struct Ticket {
        let values: [Int]

        init(rawString: String) {
            values = rawString.split(separator: ",").compactMap { Int($0) }
        }
    }
}

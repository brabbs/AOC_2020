//
//  Day16.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation
import Regex

struct Day16: Solution {
    let fields: [Field]
    let tickets: [Ticket]
    let myTicket: Ticket

    init(input: String) {
        let parts = input.components(separatedBy: "\n\n")
        fields = parts[0]
            .components(separatedBy: "\n")
            .compactMap(Field.init(rawString:))
        let myTicketString = parts[1].drop { (character: Character) in !character.isNumber }
        myTicket = Ticket(rawString: String(myTicketString))
        tickets = parts[2]
            .components(separatedBy: "\n")
            .filter { $0.contains(",") }
            .map(Ticket.init(rawString:))
    }

    func first() -> Any {
        let totalRange = time { getTotalRange() }
        let invalidValues = time { tickets.lazy
            .flatMap(\.values)
            .filter { !totalRange.contains($0) }
        }
        return time { invalidValues.sum() }
    }

    func second() -> Any {
        let validTickets = getValidTickets()
        var possibleFields = stride(from: 0, to: fields.count, by: 1)
            .reduce(into: [Int: [Field]]()) { result, position in
                result[position] = fields
            }

        for ticket in validTickets {
            for (position, value) in ticket.values.enumerated() {
                let currentPossible = possibleFields[position] ?? []
                possibleFields[position] = currentPossible.filter { field in
                    field.canHaveValue(value)
                }
            }
        }

        let fieldNames = fields.map(\.name)
        let possibleFieldsGraph =  BipartiteGraph(
            left: 0..<fields.count,
            right: fieldNames
        ) { position, fieldName in
            possibleFields[position]?.contains { $0.name == fieldName } ?? false
        }

        guard let matching = possibleFieldsGraph.leftPerfectMatching() else {
            return "No solution"
        }

        let departureFieldNames = fieldNames.filter { $0.hasPrefix("departure") }
        let myTicketDepartureValues = departureFieldNames
            .compactMap { fieldName in matching.first(where: { $0.right == fieldName}) }
            .map(\.left)
            .map { myTicket.values[$0] }

        return myTicketDepartureValues.reduce(1, *)
    }

    /// A set of all numbers in the range of some field
    func getTotalRange() -> Set<Int> {
        fields
            .flatMap { [$0.lowRange, $0.highRange] }
            .reduce(into: Set()) { $0.formUnion($1) }
    }

    func getValidTickets() -> [Ticket] {
        let totalRange = getTotalRange()
        return (tickets + [myTicket])
            .filter { ticket in ticket.values.allSatisfy({ totalRange.contains($0) }) }
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

        func canHaveValue(_ value: Int) -> Bool {
            lowRange.contains(value) || highRange.contains(value)
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

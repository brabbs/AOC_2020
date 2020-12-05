//
//  DayTemplate.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation

struct Day05: Solution {
    let seats: [Seat]

    init(input: String) {
        seats = input
            .components(separatedBy: "\n")
            .compactMap(Seat.init(rawString:))
    }

    func first() -> Any {
        seats.lazy.map(\.id).max() ?? -1
    }

    func second() -> Any {
        "Second answer not yet implemented"
    }
}

extension Day05 {
    struct Seat: CustomStringConvertible {
        let row, column: Int
        var id: Int { row * 8 + column }

        var description: String {
            "row \(row), column \(column), seat ID \(id)"
        }

        init?(rawString: String) {
            let rowCode = String(rawString.prefix(7))
            let columnCode = String(rawString.suffix(3))
            guard let decodedRow = Self.decodeBinary(rowCode, zero: "F", one: "B") else {
                return nil
            }
            guard let decodedColumn = Self.decodeBinary(columnCode, zero: "L", one: "R") else {
                return nil
            }
            row = decodedRow
            column = decodedColumn
        }

        static func decodeBinary(_ coded: String, zero: Character, one: Character) -> Int? {
            let binaryString = coded.reduce("") { binary, code in
                switch code {
                case zero: return binary + "0"
                case one: return binary + "1"
                default: return binary
                }
            }
            return Int(binaryString, radix: 2)
        }
    }
}

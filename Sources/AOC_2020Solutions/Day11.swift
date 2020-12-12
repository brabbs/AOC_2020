//
//  Day11.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation

struct Day11: Solution {
    let plan: SeatingPlan

    init(input: String) {
        plan = SeatingPlan(rawString: input)
    }

    func first() -> Any {
        var movingPlan = plan
        var changeCount = -1
        while changeCount != 0 {
            changeCount = movingPlan.move()
        }
        return movingPlan.occupiedSeats()
    }

    func second() -> Any {
        "Second answer not yet implemented"
    }
}

extension Day11 {
    struct SeatingPlan {
        var layout: [[Item]]
        let width: Int
        let height: Int

        init(rawString: String) {
            layout = rawString
                .split(separator: "\n")
                .map { row in row.compactMap(Item.init) }
            width = layout[0].count
            height = layout.count
        }

        subscript(column: Int, row: Int) -> Item? {
            guard
                0 <= column && column < width,
                0 <= row && row < height
            else {
                return nil
            }

            return layout[row][column]
        }

        mutating func move() -> Int {
            var changeCount = 0
            let newLayout = (0..<height).map { (row: Int) -> [Item] in
                (0..<width).map { (column: Int) -> Item in
                    let newItem = itemAfterMoveAt(column, row)
                    if newItem != self[column, row] {
                        changeCount += 1
                    }
                    return newItem
                }
            }
            layout = newLayout
            return changeCount
        }

        func itemAfterMoveAt(_ column: Int, _ row: Int) -> Item {
            guard let item = self[column, row] else {
                return .floor
            }

            switch item {
            case .floor: return .floor
            case .empty:
                let neighbours = neighboursOfSeat(column, row)
                return emptySeatWillFill(surroundedBy: neighbours) ? .occupied : .empty
            case .occupied:
                let neighbours = neighboursOfSeat(column, row)
                return occupiedSeatWillEmpty(surroundedBy: neighbours) ? .empty : .occupied
            }
        }

        func emptySeatWillFill(surroundedBy neighbours: [Item]) -> Bool {
            !neighbours.contains(.occupied)
        }

        func occupiedSeatWillEmpty(surroundedBy neighbours: [Item]) -> Bool {
            neighbours.count(of: .occupied) >= 4
        }

        func neighboursOfSeat(_ column: Int, _ row: Int) -> [Item] {
            Self.directionVectors.compactMap { vector in
                self[column + vector.0, row + vector.1]
            }
        }

        static let directionVectors: [(Int, Int)] = {
            let modifiers = [-1, 0, 1]
            return modifiers.flatMap { left in
                modifiers.compactMap { right in
                    guard left != 0 || right != 0 else { return nil }
                    return (left, right)
                }
            }
        }()

        func occupiedSeats() -> Int {
            layout
                .map { row in row.count(of: .occupied) }
                .sum()
        }
    }
}

extension Day11.SeatingPlan {
    enum Item: CustomStringConvertible {
        case floor
        case empty
        case occupied

        init?(_ character: Character) {
            switch character {
            case ".": self = .floor
            case "L": self = .empty
            default: return nil
            }
        }

        var description: String {
            switch self {
            case .floor: return "."
            case .empty: return "L"
            case .occupied: return "#"
            }
        }
    }
}

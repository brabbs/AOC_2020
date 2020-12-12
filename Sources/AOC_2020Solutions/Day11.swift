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
        var movingPlan = plan
        while true {
            let layout = movingPlan.layout
            movingPlan.moveTwo()
            let newLayout = movingPlan.layout

            let changed = newLayout.enumerated().contains { y, row in
                row.enumerated().contains { x, item in
                    item != layout[y][x]
                }
            }
            if !changed { break }
        }
        return movingPlan.occupiedSeats()
    }
}

extension Day11 {
    struct SeatingPlan {
        var layout: [[Item]]
        let width: Int
        let height: Int
        lazy var sightlineNeighbours = getSightlineNeighbours()

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

        func occupiedSeatWillEmpty(surroundedBy neighbours: [Item], threshold: Int = 4) -> Bool {
            neighbours.count(of: .occupied) >= threshold
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
                .lazy
                .map { row in row.count(of: .occupied) }
                .sum()
        }

        // MARK: Move Two

        mutating func moveTwo() {
            let newLayout = (0..<height).map { (row: Int) -> [Item] in
                (0..<width).map { (column: Int) -> Item in
                    itemAfterMoveTwoAt(column, row)
                }
            }
            layout = newLayout
        }

        mutating func itemAfterMoveTwoAt(_ column: Int, _ row: Int) -> Item {
            guard let item = self[column, row] else {
                return .floor
            }

            let neighbours = sightlineNeighbours[Location(x: column, y: row)]?
                .compactMap { self[$0.x, $0.y] }
                ?? []

            switch item {
            case .floor: return .floor
            case .empty:
                let willFill = emptySeatWillFill(surroundedBy: neighbours)
                return willFill ? .occupied : .empty
            case .occupied:
                let willEmpty = occupiedSeatWillEmpty(surroundedBy: neighbours, threshold: 5)
                return willEmpty ? .empty : .occupied
            }
        }

        // MARK: Sightline Neighbours

        func getSightlineNeighbours() -> [Location: [Location]] {
            (0..<width).reduce(into: [Location: [Location]]()) { neighbours, x in
                neighbours = (0..<height).reduce(into: neighbours) { neighbours, y in
                    let location = Location(x: x, y: y)
                    neighbours[location] = getSightlineNeighboursFrom(location)
                }
            }
        }

        func getSightlineNeighboursFrom(_ location: Location) -> [Location] {
            Self.directionVectors.compactMap { direction in
                getSightlineNeighbourFrom(location, direction: direction)
            }
        }

        func getSightlineNeighbourFrom(
            _ location: Location,
            direction: (x: Int, y: Int)
        ) -> Location? {
            var neighbourLocation = location
            while true {
                // Keep moving in the direction until we find a chair
                neighbourLocation = Location(
                    x: neighbourLocation.x + direction.x,
                    y: neighbourLocation.y + direction.y)
                guard let item = self[neighbourLocation.x, neighbourLocation.y] else {
                    // We've got to the edge of the board
                    return nil
                }

                switch item {
                case .empty, .occupied: return neighbourLocation
                case .floor: continue
                }
            }
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

extension Day11.SeatingPlan {
    struct Location: Hashable {
        let x, y: Int
    }
}

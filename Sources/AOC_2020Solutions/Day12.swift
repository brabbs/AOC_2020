//
//  Day12.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation

struct Day12: Solution {
    let instructions: [Ship.Instruction]

    init(input: String) {
        instructions = input
            .components(separatedBy: "\n")
            .compactMap(Ship.Instruction.init(rawSting:))
    }

    func first() -> Any {
        var ship = Ship()
        for instruction in instructions {
            ship.enact(instruction)
        }
        return ship.distanceFromOrigin
    }

    func second() -> Any {
        "Second answer not yet implemented"
    }
}

extension Day12 {
    struct Ship {
        var location = Location.origin
        var bearing = Bearing.east

        mutating func enact(_ instruction: Instruction) {
            switch instruction.action {
            case .move(let instructionBearing): move(instruction.value, on: instructionBearing)
            case .turnClockwise: turnClockwise(instruction.value)
            case .forward: move(instruction.value, on: bearing)
            }
        }

        mutating func move(_ distance: Int, on bearing: Bearing) {
            switch bearing {
            case .east: location.east += distance
            case .west: location.east -= distance
            case .north: location.north += distance
            case .south: location.north -= distance
            }
        }

        mutating func turnClockwise(_ quarterTurns: Int) {
            bearing = bearing.turningClockwise(quarterTurns)
        }

        var distanceFromOrigin: Int {
            location.manhattenDistance(from: .origin)
        }
    }
}

extension Day12.Ship {
    struct Location {
        var east, north: Int
        static let origin = Location(east: 0, north: 0)

        func manhattenDistance(from location: Location) -> Int {
            abs(east - location.east) + abs(north - location.north)
        }
    }
}

extension Day12.Ship {
    enum Bearing: Int {
        case east, south, west, north

        func turningClockwise(_ quarterTurns: Int) -> Bearing {
            let newRawValue = (((rawValue + quarterTurns) % 4) + 4) % 4
            return Bearing.init(rawValue: newRawValue)!
        }
    }
}

extension Day12.Ship {
    struct Instruction {
        let action: Action
        let value: Int

        init?(rawSting: String) {
            guard let actionLetter = rawSting.first else { return nil }
            guard let rawValue = Int(rawSting.dropFirst()) else { return nil }

            switch actionLetter {
            case "N":
                action = .move(.north)
                value = rawValue
            case "S":
                action = .move(.south)
                value = rawValue
            case "E":
                action = .move(.east)
                value = rawValue
            case "W":
                action = .move(.west)
                value = rawValue
            case "L":
                action = .turnClockwise
                value = -rawValue / 90
            case "R":
                action = .turnClockwise
                value = rawValue / 90
            case "F":
                action = .forward
                value = rawValue
            default: return nil
            }
        }
    }


}

extension Day12.Ship.Instruction {
    enum Action {
        case move(Day12.Ship.Bearing)
        case turnClockwise
        case forward
    }
}

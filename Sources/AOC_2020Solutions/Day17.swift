//
//  Day17.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation

struct Day17: Solution {
    let initiallyActive: Set<Location>

    init(input: String) {
        var initiallyActive = Set<Location>()
        for (y, row) in input.split(separator: "\n").enumerated() {
            for (x, character) in row.enumerated() {
                if character == "#" {
                    initiallyActive.insert(Location(x: x, y: y, z: 0, w: 0))
                }
            }
        }
        self.initiallyActive = initiallyActive
    }

    func first() -> Any {
        var pocketDimension = PocketDimension(activeCubes: initiallyActive, dimensions: .three)
        for _ in 0..<6 {
            time { pocketDimension.cycle() }
        }
        return pocketDimension.activeCubes.count
    }

    func second() -> Any {
        var pocketDimension = PocketDimension(activeCubes: initiallyActive, dimensions: .four)
        for _ in 0..<6 {
            time { pocketDimension.cycle() }
        }
        return pocketDimension.activeCubes.count
    }
}

extension Day17 {
    struct PocketDimension {
        private(set) var activeCubes: Set<Location>
        let dimensions: Dimensions

        mutating func cycle() {
            var newActiveCubes = Set<Location>()
            var inactiveNeighbours = Set<Location>()

            for activeCube in activeCubes {
                let neighbours = getNeighbours(of: activeCube)
                let activeNeighbours = neighbours.intersection(activeCubes)
                // Active cubes stay active if surrounded by 2 or 3 active cubes
                if (2...3).contains(activeNeighbours.count) {
                    newActiveCubes.insert(activeCube)
                }
                // Inactive neighbours are liable to turn on
                inactiveNeighbours.formUnion(neighbours.subtracting(activeNeighbours))
            }

            for inactiveCube in inactiveNeighbours {
                let activeNeighbours = getNeighbours(of: inactiveCube).intersection(activeCubes)
                // Inactive cubes turn on if surrounded by three active cubes
                if activeNeighbours.count == 3 {
                    newActiveCubes.insert(inactiveCube)
                }
            }

            activeCubes = newActiveCubes
        }

        func getNeighbours(of location: Location) -> Set<Location> {
            let steps: Set<Location>
            switch dimensions {
            case .three: steps = Location.threeDimNeighbourSteps
            case .four: steps = Location.fourDimNeighbourSteps
            }

            return Set(steps.map { location + $0 })
        }
    }
}

extension Day17.PocketDimension {
    enum Dimensions {
        case three, four
    }
}

extension Day17 {
    struct Location: Hashable, CustomStringConvertible, Comparable {
        let x, y, z, w: Int

        var description: String {
            "(\(x), \(y), \(z), \(w)"
        }

        static func < (lhs: Day17.Location, rhs: Day17.Location) -> Bool {
            [lhs.x, lhs.y, lhs.z, lhs.w].lexicographicallyPrecedes([rhs.x, rhs.y, rhs.z, rhs.w])
        }

        static func + (lhs: Location, rhs: Location) -> Location {
            Location(
                x: lhs.x + rhs.x,
                y: lhs.y + rhs.y,
                z: lhs.z + rhs.z,
                w: lhs.w + rhs.w)
        }

        static let zero = Location(x: 0, y: 0, z: 0, w: 0)

        static let fourDimNeighbourSteps: Set<Location> = {
            var neighbourSteps: Set<Location> = [.zero]
            neighbourSteps.formUnion(neighbourSteps.map { $0 + .init(x:1, y:0, z:0, w:0) })
            neighbourSteps.formUnion(neighbourSteps.map { $0 + .init(x:-1, y:0, z:0, w:0) })
            neighbourSteps.formUnion(neighbourSteps.map { $0 + .init(x:0, y:1, z:0, w:0) })
            neighbourSteps.formUnion(neighbourSteps.map { $0 + .init(x:0, y:-1, z:0, w:0) })
            neighbourSteps.formUnion(neighbourSteps.map { $0 + .init(x:0, y:0, z:1, w:0) })
            neighbourSteps.formUnion(neighbourSteps.map { $0 + .init(x:0, y:0, z:-1, w:0) })
            neighbourSteps.formUnion(neighbourSteps.map { $0 + .init(x:0, y:0, z:0, w:1) })
            neighbourSteps.formUnion(neighbourSteps.map { $0 + .init(x:0, y:0, z:0, w:-1) })
            neighbourSteps.remove(.zero)
            return neighbourSteps
        }()

        static let threeDimNeighbourSteps: Set<Location> = {
            fourDimNeighbourSteps.filter { $0.w == 0 }
        }()
    }
}

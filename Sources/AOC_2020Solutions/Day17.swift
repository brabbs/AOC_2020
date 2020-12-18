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
                    initiallyActive.insert(Location(x: x, y: y, z: 0))
                }
            }
        }
        self.initiallyActive = initiallyActive
    }

    func first() -> Any {
        var pocketDimension = PocketDimension(activeCubes: initiallyActive)
        for _ in 0..<6 {
            time { pocketDimension.cycle() }
        }
        return pocketDimension.activeCubes.count
    }

    func second() -> Any {
        "Second answer not yet implemented"
    }
}

extension Day17 {
    struct PocketDimension {
        private(set) var activeCubes: Set<Location>

        mutating func cycle() {
            var newActiveCubes = Set<Location>()
            var inactiveNeighbours = Set<Location>()

            for activeCube in activeCubes {
                let neighbours = activeCube.neighbours()
                let activeNeighbours = neighbours.intersection(activeCubes)
                // Active cubes stay active if surrounded by 2 or 3 active cubes
                if (2...3).contains(activeNeighbours.count) {
                    newActiveCubes.insert(activeCube)
                }
                // Inactive neighbours are liable to turn on
                inactiveNeighbours.formUnion(neighbours.subtracting(activeNeighbours))
            }

            for inactiveCube in inactiveNeighbours {
                let activeNeighbours = inactiveCube.neighbours().intersection(activeCubes)
                // Inactive cubes turn on if surrounded by three active cubes
                if activeNeighbours.count == 3 {
                    newActiveCubes.insert(inactiveCube)
                }
            }

            activeCubes = newActiveCubes
        }
    }
}

extension Day17 {
    struct Location: Hashable, CustomStringConvertible, Comparable {
        static func < (lhs: Day17.Location, rhs: Day17.Location) -> Bool {
            if lhs.x < rhs.x {
                return true
            } else if lhs.x > rhs.x {
                return false
            }

            if lhs.y < rhs.y {
                return true
            } else if lhs.y > rhs.y {
                return false
            }

            return lhs.z < rhs.z
        }

        let x, y, z: Int

        var description: String {
            "(\(x), \(y), \(z))"
        }

        func neighbours() -> Set<Location> {
            // It's fastest just to list all the neighbours
            return [
                Location(x: x + 1, y: y    , z: z    ),
                Location(x: x - 1, y: y    , z: z    ),
                Location(x: x    , y: y + 1, z: z    ),
                Location(x: x + 1, y: y + 1, z: z    ),
                Location(x: x - 1, y: y + 1, z: z    ),
                Location(x: x    , y: y - 1, z: z    ),
                Location(x: x + 1, y: y - 1, z: z    ),
                Location(x: x - 1, y: y - 1, z: z    ),
                Location(x: x    , y: y    , z: z + 1),
                Location(x: x + 1, y: y    , z: z + 1),
                Location(x: x - 1, y: y    , z: z + 1),
                Location(x: x    , y: y + 1, z: z + 1),
                Location(x: x + 1, y: y + 1, z: z + 1),
                Location(x: x - 1, y: y + 1, z: z + 1),
                Location(x: x    , y: y - 1, z: z + 1),
                Location(x: x + 1, y: y - 1, z: z + 1),
                Location(x: x - 1, y: y - 1, z: z + 1),
                Location(x: x    , y: y    , z: z - 1),
                Location(x: x + 1, y: y    , z: z - 1),
                Location(x: x - 1, y: y    , z: z - 1),
                Location(x: x    , y: y + 1, z: z - 1),
                Location(x: x + 1, y: y + 1, z: z - 1),
                Location(x: x - 1, y: y + 1, z: z - 1),
                Location(x: x    , y: y - 1, z: z - 1),
                Location(x: x + 1, y: y - 1, z: z - 1),
                Location(x: x - 1, y: y - 1, z: z - 1),
            ]
        }
    }
}

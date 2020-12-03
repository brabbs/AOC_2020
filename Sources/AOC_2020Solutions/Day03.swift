//
//  Day03.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation

struct Day03: Solution {
    let slope: Slope

    init(input: String) {
        slope = Slope(rawString: input)
    }

    func first() -> Any {
        time { treesOnSlope(down: 1, right: 3) }
    }

    func second() -> Any {
        let directions = [
            (down: 1, right: 1),
            (down: 1, right: 3),
            (down: 1, right: 5),
            (down: 1, right: 7),
            (down: 2, right: 1),
        ]
        return directions
            .map { treesOnSlope(down: $0.down, right: $0.right) }
            .reduce(1, *)
    }

    func treesOnSlope(down: Int, right: Int) -> Int {
        stride(from: 0, to: slope.height, by: down)
            .lazy
            .map { row in slope[row/down * right, row] }
            .count(of: .tree)
    }
}

extension Day03 {
    struct Slope {
        let height: Int

        let map: [[Item]]
        let mapWidth: Int

        init(rawString: String) {
            map = rawString
                .split(separator: "\n")
                .map { row in row.compactMap(Item.init) }
            height = map.count
            mapWidth = map[0].count
        }

        subscript(x: Int, y: Int) -> Item {
            let xInRange = x % mapWidth
            return map[y][xInRange]
        }

        enum Item {
            case open, tree

            init?(_ character: Character) {
                switch character {
                case ".": self = .open
                case "#": self = .tree
                default: return nil
                }
            }
        }
    }
}

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
        time {
            (0..<slope.height)
                .lazy
                .map { row in slope[row * 3, row] }
                .count(of: .tree)
        }
    }

    func second() -> Any {
        "Second answer not yet implemented"
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

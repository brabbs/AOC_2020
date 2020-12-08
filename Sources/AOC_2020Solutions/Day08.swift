//
//  Day08.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation

struct Day08: Solution {
    let instructions: [Instruction]

    init(input: String) {
        instructions = input
            .components(separatedBy: "\n")
            .compactMap(Instruction.init(rawString:))
    }

    func first() -> Any {
        var console = Console(instructions: instructions)
        console.runUntilLoop()
        return console.accumulator
    }

    func second() -> Any {
        "Second answer not yet implemented"
    }
}

extension Day08 {
    enum Instruction {
        case noOperation
        case accumulate(Int)
        case jump(Int)

        init?(rawString: String) {
            let parts = rawString.split(separator: " ")
            guard parts.count == 2 else { return nil }
            let operation = parts[0]
            guard let argument = Int(parts[1]) else { return nil }
            switch operation {
            case "nop": self = .noOperation
            case "acc": self = .accumulate(argument)
            case "jmp": self = .jump(argument)
            default: return nil
            }
        }
    }
}

extension Day08 {
    struct Console {
        private(set) var accumulator = 0
        private var programPosition = 0
        let instructions: [Instruction]

        init(instructions: [Instruction]) {
            self.instructions = instructions
        }

        mutating func runUntilLoop() {
            var positionsRun = Set<Int>()
            while !positionsRun.contains(programPosition) {
                positionsRun.insert(programPosition)

                let instruction = instructions[programPosition]
                switch instruction {
                case .noOperation:
                    programPosition += 1
                case .accumulate(let argument):
                    accumulator += argument
                    programPosition += 1
                case .jump(let argument):
                    programPosition += argument
                }
            }
        }
    }
}

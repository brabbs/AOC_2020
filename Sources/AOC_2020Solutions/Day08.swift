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
        let endState = console.run()
        if case .infiniteLoop(let accumulator) = endState {
            return accumulator
        } else {
            return "Unexpectedly terminated!!!"
        }
    }

    func second() -> Any {
        for (flipPosition, originalInstruction) in instructions.enumerated() {

            let flippedInstruction: Instruction
            switch originalInstruction.operation {
            case .accumulate: continue
            case .jump:
                flippedInstruction = Instruction(
                    operation: .noOperation,
                    argument: originalInstruction.argument)
            case .noOperation:
                flippedInstruction = Instruction(
                    operation: .jump,
                    argument: originalInstruction.argument)
            }

            var trialInstructions = instructions
            trialInstructions[flipPosition] = flippedInstruction
            var console = Console(instructions: trialInstructions)

            if case .terminated(let accumulator) = console.run() {
                return accumulator
            }
        }

        return "Not finished"
    }
}

extension Day08 {
    struct Instruction {
        enum Operation {
            case noOperation
            case accumulate
            case jump
        }

        let operation: Operation
        let argument: Int

        init?(rawString: String) {
            let parts = rawString.split(separator: " ")
            guard parts.count == 2 else { return nil }

            guard let argument = Int(parts[1]) else { return nil }
            self.argument = argument

            switch parts[0] {
            case "nop": operation = .noOperation
            case "acc": operation = .accumulate
            case "jmp": operation = .jump
            default: return nil
            }
        }

        init(operation: Operation, argument: Int) {
            self.operation = operation
            self.argument = argument
        }
    }
}

extension Day08 {
    struct Console {
        private(set) var accumulator = 0
        private var programPosition = 0
        let instructions: [Instruction]
        private var terminationPosition: Int { instructions.count }

        init(instructions: [Instruction]) {
            self.instructions = instructions
        }

        enum EndState {
            case infiniteLoop(Int)
            case terminated(Int)
        }

        mutating func run() -> EndState {
            reset()

            var positionsRun = Set<Int>()
            while (
                programPosition != terminationPosition &&
                !positionsRun.contains(programPosition)
            ) {
                positionsRun.insert(programPosition)
                run(instructions[programPosition])
            }

            if programPosition == terminationPosition {
                return .terminated(accumulator)
            } else {
                return .infiniteLoop(accumulator)
            }
        }

        private mutating func reset() {
            accumulator = 0
            programPosition = 0
        }

        private mutating func run(_ instruction: Instruction) {
            switch instruction.operation {
            case .noOperation:
                programPosition += 1
            case .accumulate:
                accumulator += instruction.argument
                programPosition += 1
            case .jump:
                programPosition += instruction.argument
            }
        }
    }
}

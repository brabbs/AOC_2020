//
//  Day14.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation
import Regex

struct Day14: Solution {
    let instructions: [PortComputer.Instruction]

    init(input: String) {
        instructions = input
            .components(separatedBy: "\n")
            .compactMap(PortComputer.Instruction.init(rawString:))
    }

    func first() -> Any {
        var portComputer = PortComputer()
        time { portComputer.runInitialisation(program: instructions) }
        return portComputer.memorySum()
    }

    func second() -> Any {
        "Second answer not yet implemented"
    }
}

extension Day14 {
    struct PortComputer {
        var memory = [Int: Int]()
        var mask: Instruction.Mask = .trivial

        mutating func runInitialisation(program: [Instruction]) {
            for instruction in program {
                switch instruction {
                case .mask(let newMask): mask = newMask
                case .write(let writeInstruction): run(writeInstruction)
                }
            }
        }

        mutating func run(_ writeInstruction: Instruction.Write) {
            let maskedValue = writeInstruction.value & mask.mask
            let finalValue = maskedValue + mask.addition
            memory[writeInstruction.address] = finalValue
        }

        /// Sum of all values in the memory
        func memorySum() -> Int {
            memory.lazy.map(\.value).sum()
        }
    }
}

extension Day14.PortComputer {
    enum Instruction: CustomStringConvertible {
        case mask(Mask)
        case write(Write)

        init?(rawString: String) {
            if rawString.hasPrefix("mask") {
                self = .mask(Mask(rawString: rawString))
            } else if rawString.hasPrefix("mem"), let instruction = Write(rawString: rawString) {
                self = .write(instruction)
            } else {
                return nil
            }
        }

        var description: String {
            switch self {
            case .mask(let mask): return "MASK:\n\(mask)"
            case .write(let write): return "WRITE: \(write)"
            }
        }
    }
}

extension Day14.PortComputer.Instruction {
    struct Write: CustomStringConvertible {
        let address: Int
        let value: Int

        static let regex = Regex(#"^mem\[(\d+)\] = (\d+)$"#)

        init?(rawString: String) {
            guard
                let captures = Self.regex.firstMatch(in: rawString)?.captures,
                let address = captures[0].flatMap({ Int($0) }),
                let value = captures[1].flatMap({ Int($0) })
            else {
                return nil
            }

            self.address = address
            self.value = value
        }

        var description: String {
            "mem[\(address)] = \(value)"
        }

    }

    struct Mask: CustomStringConvertible {
        let mask: Int
        let addition: Int

        /// Leaves everything unchanged
        static let trivial = Mask(rawString: "mask = \(String(repeating: "X", count: 32))")

        init(rawString: String) {
            let code = rawString.split(separator: " ")[2]
            let maskString = code.reduce("") { binary, character in
                // Only let through where we have an X
                if character == "X" {
                    return binary + "1"
                } else {
                    return binary + "0"
                }
            }
            mask = Int(maskString, radix: 2) ?? 0

            let additionString = code.reduce("") { binary, character in
                // Only keep the 1s
                if character != "1" {
                    return binary + "0"
                } else {
                    return binary + "1"
                }
            }

            addition = Int(additionString, radix: 2) ?? 0
        }

        var description: String {
            let maskDescription = String(mask, radix: 2)
            let maskPadding = String(repeating: "0", count: 36 - maskDescription.count)
            let additionDescription = String(addition, radix: 2)
            let additionPadding = String(repeating: "0", count: 36 - additionDescription.count)
            return """
                Mask: \(maskPadding)\(maskDescription)
                Add:  \(additionPadding)\(additionDescription)
            """
        }
    }
}

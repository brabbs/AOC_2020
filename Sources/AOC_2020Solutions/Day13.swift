//
//  Day13.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation
import BigNumber

struct Day13: Solution {
    let earliestDeparture: Int
    let busIds: [Int]
    let conditions: [ModuloCondition]

    init(input: String) {
        let parts = input.split(separator: "\n")
        earliestDeparture = Int(parts[0]) ?? 0

        let busInfo = parts[1].split(separator: ",")
        busIds = busInfo.compactMap { Int($0) }

        conditions = busInfo.enumerated().compactMap { (i, substring) in
            guard let busId = Int(substring) else { return nil }
            return ModuloCondition(modulus: busId, remainder: -i)
        }
    }

    func first() -> Any {
        guard let firstBusAndWait = getFirstBusAndWait() else {
            return "No Bus IDs"
        }

        return firstBusAndWait.0 * firstBusAndWait.1
    }

    func getFirstBusAndWait() -> (Int, Int)? {
        busIds
            .lazy
            // Calculate minutes after earliest departure of each bus
            .map { ($0, $0 - (earliestDeparture % $0)) }
            .min { $0.1 <= $1.1 }
    }

    func second() -> Any {
        let totalCondition = time { () -> ModuloCondition in
            conditions.reduce(.trivial) { result, nextCondition in
                (result && nextCondition)!
            }
        }
        
        return totalCondition.firstPositiveSolution
    }
}

struct ModuloCondition: CustomStringConvertible {
    let modulus: BInt
    let remainder: BInt

    init(modulus: Int, remainder: Int) {
        self.modulus = BInt(modulus)
        self.remainder = BInt(remainder % modulus)
    }

    init(modulus: BInt, remainder: BInt) {
        self.modulus = modulus
        self.remainder = remainder % modulus
    }

    var description: String {
        "t = \(remainder) (mod \(modulus))"
    }

    var firstPositiveSolution: BInt {
        (remainder + modulus) % modulus
    }

    static func && (left: ModuloCondition, right: ModuloCondition) -> ModuloCondition? {
        let bezoutsIdentity = BezoutsIdentity(left.modulus, -right.modulus)
        let remainderDifference = right.remainder - left.remainder

        guard remainderDifference % bezoutsIdentity.gcd == 0 else {
            // The conditions can't be satisfied simultaneously
            return nil
        }

        let remainder = (left.modulus * bezoutsIdentity.x * remainderDifference)
            / bezoutsIdentity.gcd
            + left.remainder
        let modulus = (left.modulus * right.modulus) / abs(bezoutsIdentity.gcd)

        return ModuloCondition(modulus: modulus, remainder: remainder)
    }

    /// Condition satisfied by every integer
    static let trivial = ModuloCondition(modulus: 1, remainder: 0)
}

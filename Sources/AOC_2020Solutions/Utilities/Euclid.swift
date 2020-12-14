//
//  File.swift
//  
//
//  Created by Nicholas Brabbs on 13/12/2020.
//

import Foundation
import BigNumber

/// The components of Bézout's Identity
///
/// ax + by = gcd(a, b)
struct BezoutsIdentity: CustomStringConvertible {
    let a, b: BInt
    let x, y: BInt
    let gcd: BInt

    var description: String {
        "\(a)*\(x) + \(b)*\(y) = \(gcd)"
    }

    init(_ a: Int, _ b: Int) {
        self = .init(BInt(a), BInt(b))
    }

    /// Calculates the coefficients of Bezout's Identity
    init(_ a: BInt, _ b: BInt) {
        var rOld = a
        var rNew = b

        var sOld = BInt(1)
        var sNew = BInt(0)

        var tOld = BInt(0)
        var tNew = BInt(1)

        while rNew != 0 {
            let quotient = BInt(floor(Double(rOld / rNew)))
            (rOld, rNew) = (rNew, rOld - quotient*rNew)
            (sOld, sNew) = (sNew, sOld - quotient*sNew)
            (tOld, tNew) = (tNew, tOld - quotient*tNew)
        }

        self.a = a
        self.b = b

        self.x = sOld
        self.y = tOld

        self.gcd = rOld
    }
}

//
//  Day16Test.swift
//  
//
//  Created by Nicholas Brabbs on 02/12/2020.
//

import XCTest
import AOC_2020Solutions
import BigNumber

final class Day16Test: XCTestCase {
    func testPartOne() throws {
        let solution = try getSolution(16)
        let first = try XCTUnwrap(solution.first() as? Int)
        XCTAssertEqual(first, 26053)
    }
}

//
//  Day13Test.swift
//  
//
//  Created by Nicholas Brabbs on 02/12/2020.
//

import XCTest
import AOC_2020Solutions
import BigNumber

final class Day13Test: XCTestCase {
    func testPartOne() throws {
        let solution = try getSolution(13)
        let first = try XCTUnwrap(solution.first() as? Int)
        XCTAssertEqual(first, 3789)
    }

    func testPartTwo() throws {
        let solution = try getSolution(13)
        let second = try XCTUnwrap(solution.second() as? BInt)
        XCTAssertEqual(second, 667437230788118)
    }
}

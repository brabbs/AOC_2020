//
//  Day14Test.swift
//  
//
//  Created by Nicholas Brabbs on 02/12/2020.
//

import XCTest
import AOC_2020Solutions
import BigNumber

final class Day14Test: XCTestCase {
    func testPartOne() throws {
        let solution = try getSolution(14)
        let first = try XCTUnwrap(solution.first() as? Int)
        XCTAssertEqual(first, 7477696999511)
    }

    func testPartTwo() throws {
        let solution = try getSolution(14)
        let second = try XCTUnwrap(solution.second() as? Int)
        XCTAssertEqual(second, 3687727854171)
    }
}

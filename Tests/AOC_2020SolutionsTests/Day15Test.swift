//
//  Day14Test.swift
//  
//
//  Created by Nicholas Brabbs on 02/12/2020.
//

import XCTest
import AOC_2020Solutions
import BigNumber

final class Day15Test: XCTestCase {
    func testPartOne() throws {
        let solution = try getSolution(15)
        let first = try XCTUnwrap(solution.first() as? Int)
        XCTAssertEqual(first, 387)
    }

    func testPartTwo() throws {
        let solution = try getSolution(15)
        let second = try XCTUnwrap(solution.second() as? Int)
        XCTAssertEqual(second, 6428)
    }
}

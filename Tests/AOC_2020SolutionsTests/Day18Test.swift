//
//  Day17Test.swift
//  
//
//  Created by Nicholas Brabbs on 02/12/2020.
//

import XCTest
import AOC_2020Solutions

final class Day18Test: XCTestCase {
    func testPartOne() throws {
        let solution = try getSolution(18)
        let first = try XCTUnwrap(solution.first() as? Int)
        XCTAssertEqual(first, 29839238838303)
    }

    func testPartTwo() throws {
        let solution = try getSolution(18)
        let second = try XCTUnwrap(solution.second() as? Int)
        XCTAssertEqual(second, 201376568795521)
    }
}

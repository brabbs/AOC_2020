//
//  Day05Test.swift
//  
//
//  Created by Nicholas Brabbs on 02/12/2020.
//

import XCTest
import AOC_2020Solutions

final class Day05Test: XCTestCase {
    func testPartOne() throws {
        let solution = try getSolution(5)
        let first = try XCTUnwrap(solution.first() as? Int)
        XCTAssertEqual(first, 883)
    }

    func testPartTwo() throws {
        let solution = try getSolution(5)
        let first = try XCTUnwrap(solution.second() as? Int)
        XCTAssertEqual(first, 532)
    }
}

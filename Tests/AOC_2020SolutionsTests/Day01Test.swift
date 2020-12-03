//
//  Day01Test.swift
//  
//
//  Created by Nicholas Brabbs on 02/12/2020.
//

import XCTest
import AOC_2020Solutions

final class Day01Test: XCTestCase {
    func testPartOne() throws {
        let solution = try getSolution(1)
        let first = try XCTUnwrap(solution.first() as? Int)
        XCTAssertEqual(first, 1019904)
    }

    func testPartTwo() throws {
        let solution = try getSolution(1)
        let second = try XCTUnwrap(solution.second() as? Int)
        XCTAssertEqual(second, 176647680)
    }
}

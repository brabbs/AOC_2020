//
//  Day03Test.swift
//  
//
//  Created by Nicholas Brabbs on 02/12/2020.
//

import XCTest
import AOC_2020Solutions

final class Day03Test: XCTestCase {
    func testPartOne() throws {
        let solution = try getSolution(3)
        let first = try XCTUnwrap(solution.first() as? Int)
        XCTAssertEqual(first, 234)
    }

    func testPartTwo() throws {
        let solution = try getSolution(3)
        let second = try XCTUnwrap(solution.second() as? Int)
        XCTAssertEqual(second, 5813773056)
    }
}

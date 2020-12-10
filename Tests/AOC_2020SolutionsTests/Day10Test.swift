//
//  Day10Test.swift
//  
//
//  Created by Nicholas Brabbs on 02/12/2020.
//

import XCTest
import AOC_2020Solutions

final class Day10Test: XCTestCase {
    func testPartOne() throws {
        let solution = try getSolution(10)
        let first = try XCTUnwrap(solution.first() as? Int)
        XCTAssertEqual(first, 2664)
    }
}

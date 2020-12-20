//
//  Day17Test.swift
//  
//
//  Created by Nicholas Brabbs on 02/12/2020.
//

import XCTest
import AOC_2020Solutions

final class Day19Test: XCTestCase {
    func testPartOne() throws {
        let solution = try getSolution(19)
        let first = try XCTUnwrap(solution.first() as? Int)
        XCTAssertEqual(first, 248)
    }
}

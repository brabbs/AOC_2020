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
}

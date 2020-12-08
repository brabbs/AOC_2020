//
//  Day06Test.swift
//  
//
//  Created by Nicholas Brabbs on 02/12/2020.
//

import XCTest
import AOC_2020Solutions

final class Day06Test: XCTestCase {
    func testPartOne() throws {
        let solution = try getSolution(6)
        let first = try XCTUnwrap(solution.first() as? Int)
        XCTAssertEqual(first, 6911)
    }

    func testPartOnePerformance() {
        measure {
            guard let solution = try? getSolution(6) else { return }
            guard let first = try? solution.first() as? Int else { return }
            XCTAssertEqual(first, 6911)
        }
    }

    func testPartTwo() throws {
        let solution = try getSolution(6)
        let second = try XCTUnwrap(solution.second() as? Int)
        XCTAssertEqual(second, 3473)
    }

    func testPartTwoPerformance() {
        measure {
            guard let solution = try? getSolution(6) else { return }
            guard let second = try? solution.second() as? Int else { return }
            XCTAssertEqual(second, 3473)
        }
    }
}

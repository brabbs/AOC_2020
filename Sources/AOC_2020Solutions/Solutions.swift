//  Solutions.swift
//
//  Entry point for getting all solutions

import Foundation

public protocol Solution {
    init(input: String)

    func first() throws -> Any
    func second() throws -> Any
}

public enum SolutionError: Error {
    case inputFileNotFound
    case noSolutionForDay
}

public func getSolution(_ day: Int) throws -> Solution {
    let inputFileName = String(format: "Day%02d", day)
    guard let inputFileLocation = Bundle.module.url(
        forResource: inputFileName,
        withExtension: "txt"
    ) else {
        throw SolutionError.inputFileNotFound
    }
    let inputString = try String(contentsOf: inputFileLocation)

    switch day {
    case 01: return Day01(input: inputString)
    case 02: return Day02(input: inputString)
    case 03: return Day03(input: inputString)
    case 04: return Day04(input: inputString)
    case 05: return Day05(input: inputString)
    case 06: return Day06(input: inputString)
    case 07: return Day07(input: inputString)
    case 08: return Day08(input: inputString)
    case 09: return Day09(input: inputString)
    case 10: return Day10(input: inputString)
    case 11: return Day11(input: inputString)
    case 12: return Day12(input: inputString)
    case 13: return Day13(input: inputString)
    case 14: return Day14(input: inputString)
    case 15: return Day15(input: inputString)
    case 16: return Day16(input: inputString)
    case 17: return Day17(input: inputString)
    default: throw SolutionError.noSolutionForDay
    }
}

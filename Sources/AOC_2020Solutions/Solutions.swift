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
    case 1: return Day01(input: inputString)
    case 2: return Day02(input: inputString)
    case 3: return Day03(input: inputString)
    case 4: return Day04(input: inputString)
    case 5: return Day05(input: inputString)
    case 6: return Day06(input: inputString)
    case 7: return Day07(input: inputString)
    case 8: return Day08(input: inputString)
    case 9: return Day09(input: inputString)
    case 10: return Day10(input: inputString)
    case 11: return Day11(input: inputString)
    case 12: return Day12(input: inputString)
    case 13: return Day13(input: inputString)
    default: throw SolutionError.noSolutionForDay
    }
}

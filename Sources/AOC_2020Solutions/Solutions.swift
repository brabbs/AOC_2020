//  Solutions.swift
//
//  Entry point for getting all solutions

import Foundation

public protocol Solution {
    init(input: String)

    func first() -> Any
    func second() -> Any
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
    default: throw SolutionError.noSolutionForDay
    }
}

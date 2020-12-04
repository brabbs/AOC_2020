//
//  Regex.swift
//  
//
//  Created by Nicholas Brabbs on 04/12/2020.
//

import Foundation

extension String {
    func firstMatch(
        _ pattern: String,
        patternOptions: NSRegularExpression.Options = [],
        matchingOptions: NSRegularExpression.MatchingOptions = []
    ) throws -> NSTextCheckingResult? {
        let regex = try NSRegularExpression(pattern: pattern, options: patternOptions)
        let wholeRange = NSRange(location: 0, length: utf16.count)
        return regex.firstMatch(in: self, options: matchingOptions, range: wholeRange)
    }
}

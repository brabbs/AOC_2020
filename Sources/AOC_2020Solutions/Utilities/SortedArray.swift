//
//  File.swift
//  
//
//  Created by Nicholas Brabbs on 09/12/2020.
//

import Foundation

/// Wrapper of an array where we can get high performing algorithms by
/// guarunteeing that the elements of the array are sorted.
struct SortedArray<Element> where Element: Comparable {
    private let array: [Element]

    /// New SortedArray from the given sequence
    ///
    /// - Complexity: O(*n* log *n*), where *n* is the length of the sequence.
    init<S: Sequence>(_ sequence: S) where S.Element == Element {
        array = sequence.sorted()
    }
}

extension SortedArray: RandomAccessCollection {
    typealias Index = Array<Element>.Index

    var startIndex: Index { array.startIndex }
    var endIndex: Index { array.endIndex }

    subscript(index: Index) -> Element {
        array[index]
    }

    func index(after index: Index) -> Index {
        array.index(after: index)
    }
}

extension SortedArray where Element: AdditiveArithmetic {
    /// Search the the array for two elements that sum to the goal
    ///
    /// - Returns: A pair of elements that sum to the goal. nil if no such pair exists.
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    func pairSumming(to goal: Element) -> (Element, Element)? {
        guard count >= 2 else {
            // Need at least two things to make a pair
            return nil
        }

        // Start with the highest and lowest number
        var lowIndex = 0
        var highIndex = endIndex - 1

        while lowIndex != highIndex {
            let sum = self[lowIndex] + self[highIndex]

            if sum == goal {
                return (self[lowIndex], self[highIndex])
            } else if sum < goal {
                // Sum is too low, increase the lower number
                lowIndex += 1
            } else if sum > goal {
                // Sum is too high, decrease the higher number
                highIndex -= 1
            }
        }

        // Indexes met in the middle without finding a pair that sums to the goal
        return nil
    }
}

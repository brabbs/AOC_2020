//
//  Count.swift
//  
//
//  Created by Nicholas Brabbs on 02/12/2020.
//

import Foundation

extension Sequence {
    func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        try lazy.filter(predicate).count
    }
}

extension Sequence where Element: Equatable{
    func count(of element: Element) -> Int {
        count { $0 == element }
    }
}

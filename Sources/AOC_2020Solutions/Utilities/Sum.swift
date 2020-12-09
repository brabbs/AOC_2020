//
//  File.swift
//  
//
//  Created by Nicholas Brabbs on 09/12/2020.
//

import Foundation

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element {
        reduce(.zero, +)
    }
}

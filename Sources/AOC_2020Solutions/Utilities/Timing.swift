//
//  Timing.swift
//  
//
//  Created by Nicholas Brabbs on 01/12/2020.
//

import Foundation

func time<T>(_ computation: () -> T) -> T {
  let start = DispatchTime.now().uptimeNanoseconds
  defer {
    let end = DispatchTime.now().uptimeNanoseconds
    print("Took \(Double(end - start) / 1_000_000) ms")
  }
  return computation()
}

// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AOC_2020",
    products: [
        .executable(name: "AOC_2020", targets: ["AOC_2020"])
    ],
    targets: [
        .target(name: "AOC_2020Solutions", resources: [.process("Input/Day01.txt")]),
        .target(name: "AOC_2020", dependencies: ["AOC_2020Solutions"]),
        .testTarget(name: "AOC_2020Tests", dependencies: ["AOC_2020"]),
    ]
)

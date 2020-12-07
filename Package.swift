// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AOC_2020",
    products: [
        .executable(name: "AOC_2020", targets: ["AOC_2020"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            .upToNextMinor(from: "0.3.0")
        ),
        .package(url: "https://github.com/sharplet/Regex.git", from: "2.1.0"),
    ],
    targets: [
        .target(
            name: "AOC_2020Solutions",
            dependencies: ["Regex"],
            resources: [.process("Input/")]),
        .testTarget(name: "AOC_2020SolutionsTests", dependencies: ["AOC_2020Solutions"]),

        .target(name: "AOC_2020", dependencies: [
            "AOC_2020Solutions",
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
        ]),
        .testTarget(name: "AOC_2020Tests", dependencies: ["AOC_2020"]),
    ]
)

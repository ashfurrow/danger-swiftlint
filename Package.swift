// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "DangerSwiftLint",
    products: [
        .library(
            name: "DangerSwiftLint",
            targets: ["DangerSwiftLint"]),
    ],
    dependencies: [
        .package(url: "https://github.com/danger/danger-swift.git", from: "0.3.0")
    ],
    targets: [
        .target(
            name: "DangerSwiftLint",
            dependencies: []),
        .testTarget(
            name: "DangerSwiftLintTests",
            dependencies: ["DangerSwiftLint"]),
    ]
)

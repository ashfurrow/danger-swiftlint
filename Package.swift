// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "danger-swiftlint",
    products: [
        .library(
            name: "danger-swiftlint",
            targets: ["danger-swiftlint"]),
    ],
    dependencies: [
        .package(url: "https://github.com/danger/danger-swift.git", from: "0.3.0")
    ],
    targets: [
        .target(
            name: "danger-swiftlint",
            dependencies: []),
        .testTarget(
            name: "danger-swiftlintTests",
            dependencies: ["danger-swiftlint"]),
    ]
)

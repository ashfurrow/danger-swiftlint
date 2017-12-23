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
        .package(url: "https://github.com/danger/danger-swift.git", from: "0.3.0"),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "DangerSwiftLint",
            dependencies: ["Danger", "ShellOut"]),
        .testTarget(
            name: "DangerSwiftLintTests",
            dependencies: [
              "DangerSwiftLint"
            ]),
    ]
)

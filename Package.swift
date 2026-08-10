// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SinterAppleEvents",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SinterAppleEvents",
            targets: ["SinterAppleEvents"]
        )
    ],
    targets: [
        .target(
            name: "SinterAppleEvents"
        )
    ]
)

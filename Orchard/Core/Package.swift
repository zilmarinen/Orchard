// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "Container",
                 targets: ["Container"]),
    ],
    dependencies: [
        .package(path: "../Base"),
    ],
    targets: [
        .target(name: "Container",
                dependencies: [.product(name: "Base",
                                        package: "Base")]),
    ]
)

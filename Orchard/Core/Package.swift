// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "Container",
                 targets: ["Container"]),
        .library(name: "Editor",
                 targets: ["Editor"]),
    ],
    dependencies: [
        .package(path: "../Base"),
//        .package(url: "git@github.com:zilmarinen/Deltille.git",
//                 branch: "feature/refactor")
    ],
    targets: [
        .target(name: "Container",
                dependencies: [.product(name: "Base",
                                        package: "Base")]),
        .target(name: "Editor",
                dependencies: [.product(name: "Base",
                                        package: "Base")]),
    ]
)

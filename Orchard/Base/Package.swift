// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Base",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "Base",
                 targets: ["Base"]),
    ],
    dependencies: [
        .package(url: "git@github.com:zilmarinen/Deltille.git",
                 branch: "main")
    ],
    targets: [
        .target(name: "Base",
               dependencies: ["Deltille"]),
    ]
)

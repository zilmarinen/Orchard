// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Base",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "Base",
                 targets: ["Base"]),
    ],
    dependencies: [
//        .package(url: "git@github.com:zilmarinen/Deltille.git",
//                 branch: "develop")
        .package(path: "../../../Deltille"),
        .package(path: "../../../Harvest")
    ],
    targets: [
        .target(name: "Base",
                dependencies: ["Deltille",
                              "Harvest"])
    ]
)

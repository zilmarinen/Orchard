// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "Atlas",
                 targets: ["Atlas"]),
        .library(name: "Container",
                 targets: ["Container"]),
        .library(name: "Design",
                 targets: ["Design"]),
        .library(name: "Scrutinator",
                 targets: ["Scrutinator"]),
        .library(name: "Silhouette",
                 targets: ["Silhouette"]),
        .library(name: "Toolbox",
                 targets: ["Toolbox"]),
    ],
    dependencies: [
        .package(path: "../Base"),
        .package(url: "https://github.com/zilmarinen/Deltille.git",
                 branch: "main"),
        .package(path: "../../../Harvest"),
        .package(url: "git@github.com:nicklockwood/Euclid.git",
                 branch: "main")
    ],
    targets: [
        .target(name: "Atlas",
                dependencies: [.product(name: "Base",
                                        package: "Base"),
                               "Deltille",
                               "Euclid"]),
        .target(name: "Container",
                dependencies: [.product(name: "Base",
                                        package: "Base")]),
        .target(name: "Design",
                dependencies: [.product(name: "Base",
                                        package: "Base"),
                               "Container",
                               "Deltille",
                               "Harvest"]),
        .target(name: "Scrutinator",
                dependencies: [.product(name: "Base",
                                        package: "Base"),
                               "Design",
                               "Harvest"]),
        .target(name: "Silhouette",
                dependencies: [.product(name: "Base",
                                        package: "Base"),
                               "Design"]),
        .target(name: "Toolbox",
                dependencies: [.product(name: "Base",
                                        package: "Base"),
                               "Container",
                               "Design"])
    ]
)

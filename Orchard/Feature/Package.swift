// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Feature",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "Region",
                 targets: ["Region"]),
        .library(name: "Splash",
                 targets: ["Splash"]),
        .library(name: "World",
                 targets: ["World"]),
    ],
    dependencies: [
        .package(path: "../Core"),
    ],
    targets: [
        .target(name: "Region",
                dependencies: [.product(name: "Container",
                                        package: "Core"),
                               .product(name: "Editor",
                                        package: "Core")]),
        .target(name: "Splash",
                dependencies: [.product(name: "Container",
                                        package: "Core")]),
        .target(name: "World",
                dependencies: [.product(name: "Container",
                                        package: "Core"),
                               .product(name: "Editor",
                                        package: "Core"),
                               .product(name: "Inspector",
                                        package: "Core"),
                               .product(name: "OutlineView",
                                        package: "Core")]),
    ]
)

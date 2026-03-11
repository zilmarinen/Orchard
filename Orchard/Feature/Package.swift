// swift-tools-version: 6.2
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
        .package(path: "../../../Harvest")
    ],
    targets: [
        .target(name: "Region",
                dependencies: [.product(name: "Container",
                                        package: "Core"),
                               .product(name: "Design",
                                        package: "Core"),
                               .product(name: "Proscenium",
                                        package: "Core"),
                               .product(name: "Scrutinator",
                                        package: "Core"),
                               .product(name: "Silhouette",
                                        package: "Core"),
                               .product(name: "Toolbox",
                                        package: "Core"),
                               "Harvest"]),
        .target(name: "Splash",
                dependencies: [.product(name: "Container",
                                        package: "Core")]),
        .target(name: "World",
                dependencies: [.product(name: "Container",
                                        package: "Core"),
                               .product(name: "Design",
                                        package: "Core"),
                               .product(name: "Proscenium",
                                        package: "Core"),
                               .product(name: "Scrutinator",
                                        package: "Core"),
                               .product(name: "Silhouette",
                                        package: "Core"),
                               "Harvest"]),
    ]
)

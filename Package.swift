// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CommonLib",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CommonLib",
            targets: ["CommonLib"]),
    ],
    dependencies: [
        .package(url: "https://github.com/raymondxxu/Comp7005FinalProjectSocket", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CommonLib",
            dependencies: [
                .product(name: "Socket", package: "Comp7005FinalProjectSocket")
            ]),
        .testTarget(
            name: "CommonLibTests",
            dependencies: ["CommonLib"]),
    ]
)

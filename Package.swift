// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ServerShared",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "ServerShared",
            targets: ["ServerShared"]),
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.7.0"),
        .package(url: "https://github.com/PerfectlySoft/Perfect.git", from: "3.1.4"),
        
        // TEST ONLY
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", .upToNextMajor(from: "1.8.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ServerShared",
            dependencies: ["Kitura", "PerfectLib"]),
        .testTarget(
            name: "ServerSharedTests",
            dependencies: ["ServerShared", "HeliumLogger"],
            swiftSettings: [
                .define("DEBUG", .when(platforms: nil, configuration: .debug)),
                .define("SERVER")
            ]),
    ]
)

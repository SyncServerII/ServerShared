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
            
        // May be able to get rid of this when I can conditionally have dependencies in this package dependent on platform
        .library(
            name: "iOSServerShared",
            targets: ["iOSServerShared"]),
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.7.0"),
        
        // TEST ONLY
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", .upToNextMajor(from: "1.8.1"))
    ],
    // It looks like we need Swift 5.3 to have platform conditional use of packages: https://github.com/apple/swift-evolution/blob/master/proposals/0273-swiftpm-conditional-target-dependencies.md
    // i.e., to include Kitura only when on Limux
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ServerShared",
            dependencies: ["Kitura"]),
            
        // `#if os(Linux)` conditionals in the code make this different.
        .target(
            name: "iOSServerShared"),

        .testTarget(
            name: "ServerSharedTests",
            dependencies: ["ServerShared", "HeliumLogger"],
            swiftSettings: [
                .define("DEBUG", .when(platforms: nil, configuration: .debug)),
                .define("SERVER")
            ]),
    ]
)

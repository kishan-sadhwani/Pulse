// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PulseCore",
    platforms: [
        .iOS(.v16) // Sets the minimum deployment target to iOS 16
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PulseCore",
            targets: ["PulseCore"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PulseCore"
        ),
        .testTarget(
            name: "PulseCoreTests",
            dependencies: ["PulseCore"]
        ),

    ],
    swiftLanguageModes: [.v6]
)

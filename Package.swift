// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "funico-smtp",
    platforms: [
        .iOS(.v15), .macOS(.v13)
    ],
    products: [
        .library(name: "FunicoSMTP", targets: ["FunicoSMTP"])
    ],
    dependencies: [
        .package(url: "https://github.com/Funico-NV/funico-core", from: Version(1,0,0)),
        .package(url: "https://github.com/NVMNovem/swift-smtp", from: Version(1,2,0))
    ],
    targets: [
        .target(
            name: "FunicoSMTP",
            dependencies: [
                .product(name: "FunicoCore", package: "funico-core"),
                .product(name: "SwiftSMTP", package: "swift-smtp")
            ]
        ),
        .testTarget(
            name: "FunicoSMTPTests",
            dependencies: ["FunicoSMTP"]
        )
    ]
)

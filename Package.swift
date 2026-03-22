// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "LiveTimingModels",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "LiveTimingModels",
            targets: ["LiveTimingModels"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/tsolomko/SWCompression.git", from: "4.8.6"),
    ],
    targets: [
        .target(
            name: "LiveTimingModels",
            dependencies: [
                .product(name: "SWCompression", package: "SWCompression"),
            ],
            swiftSettings: [
                .swiftLanguageMode(.v6),
            ]
        ),
        .testTarget(
            name: "LiveTimingModelsTests",
            dependencies: ["LiveTimingModels"],
            swiftSettings: [
                .swiftLanguageMode(.v6),
            ]
        ),
    ]
)

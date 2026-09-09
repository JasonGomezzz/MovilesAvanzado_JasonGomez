// swift-tools-version: 5.9
// Desarrollado por: Jason Gomez

import PackageDescription

let package = Package(
    name: "SistemaMetroLima",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "MetroCore", targets: ["MetroCore"]),
        .executable(name: "SistemaMetroLima", targets: ["SistemaMetroLima"])
    ],
    targets: [
        .target(
            name: "MetroCore",
            path: "SistemaMetro.playground/Sources"
        ),
        .executableTarget(
            name: "SistemaMetroLima",
            dependencies: ["MetroCore"],
            path: "SistemaMetroCLI"
        )
    ]
)

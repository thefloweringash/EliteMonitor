// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "EliteMonitorCLI",
  platforms: [.macOS(.v14)],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
    .package(path: "../EliteMonitorCore", traits: []),
  ],
  targets: [
    .executableTarget(
      name: "EliteMonitorCLI",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "EliteJournal", package: "EliteMonitorCore"),
        .product(name: "EliteGameData", package: "EliteMonitorCore"),
      ]
    ),
  ]
)

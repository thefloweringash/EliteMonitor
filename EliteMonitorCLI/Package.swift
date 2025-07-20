// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "EliteMonitorCLI",
  platforms: [.macOS(.v15)],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
    .package(path: "../EliteMonitorCore", traits: []),
    .package(url: "https://github.com/kiliankoe/pushover", from: "1.0.0"),
    .package(url: "https://github.com/sushichop/Puppy", from: "0.9.0"),
  ],
  targets: [
    .executableTarget(
      name: "em",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "EliteJournal", package: "EliteMonitorCore"),
        .product(name: "EliteGameData", package: "EliteMonitorCore"),
        .product(name: "Pushover", package: "pushover"),
        .product(name: "Puppy", package: "puppy"),
      ]
    ),
  ]
)

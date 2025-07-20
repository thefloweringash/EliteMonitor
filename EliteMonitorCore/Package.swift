// swift-tools-version: 6.1

import Foundation
import PackageDescription

var package = Package(
  name: "EliteMonitorCore",
  defaultLocalization: "en",
  platforms: [.macOS(.v15)],
  products: [
    .library(
      name: "EliteGameData",
      targets: ["EliteGameData"]
    ),
    .library(
      name: "EliteFileUtils",
      targets: ["EliteFileUtils"]
    ),
    .library(
      name: "EliteJournal",
      targets: ["EliteJournal"],
    ),
  ],
  traits: [
    "Localization",
    .default(enabledTraits: ["Localization"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-system", from: "1.4.0"),
    .package(url: "https://github.com/apple/swift-log", from: "1.6.0"),
  ],
  targets: [
    .target(name: "EliteFileUtils", dependencies: [
      .product(name: "SystemPackage", package: "swift-system"),
      .product(name: "Logging", package: "swift-log"),
    ]),
    .target(name: "EliteJournal", dependencies: ["EliteFileUtils", "EliteGameData"]),
    .target(name: "EliteGameData"),
  ],
)

// Xcode doesn't support traits, and implicitly disables them all.
// Force on the effect of the trait for all Xcode builds as a sad compromise.
// https://forums.swift.org/t/detecting-xpm-from-package-swift/55297
if ProcessInfo.processInfo.environment["__CFBundleIdentifier"] == "com.apple.dt.Xcode" {
  print("ℹ️ Building from XCode, forcing Localization trait ")
  package.targets = package.targets.map { t in
    t.swiftSettings = [.define("Localization")]
    return t
  }
} else {
  print("ℹ️ Not building from XCode, using package traits")
}

// swift-tools-version: 6.1

import Foundation
import PackageDescription

var package = Package(
  name: "EliteMonitorCore",
  defaultLocalization: "en",
  platforms: [.macOS(.v14)],
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
  targets: [
    .target(name: "EliteFileUtils"),
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

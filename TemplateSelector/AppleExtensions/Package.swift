// swift-tools-version:5.6

import PackageDescription

let package = Package(
  name: "AppleExtensions",
  platforms: [.iOS(.v14)],
  products: [
    .library(name: "AppleExtensions", targets: ["AppleExtensions"])
  ],
  dependencies: [],
  targets: [
    .target(
      name: "AppleExtensions",
      dependencies: []
    ),
    .testTarget(name: "AppleExtensionsTests", dependencies: ["AppleExtensions"])
  ]
)

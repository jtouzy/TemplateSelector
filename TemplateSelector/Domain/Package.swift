// swift-tools-version:5.6

import PackageDescription

let package = Package(
  name: "Domain",
  platforms: [.iOS(.v14)],
  products: [
    .library(name: "Domain", targets: ["Domain"])
  ],
  dependencies: [
    .package(path: "AppleExtensions")
  ],
  targets: [
    .target(
      name: "Domain",
      dependencies: ["AppleExtensions"]
    ),
    .testTarget(name: "DomainTests", dependencies: ["Domain"])
  ]
)

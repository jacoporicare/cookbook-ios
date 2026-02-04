// swift-tools-version:6.2

import PackageDescription

let package = Package(
  name: "API",
  platforms: [
    .iOS(.v26),
    .macOS(.v26),
    .tvOS(.v26),
    .watchOS(.v11),
  ],
  products: [
    .library(name: "API", targets: ["API"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apollographql/apollo-ios.git", from: "1.25.3"),
  ],
  targets: [
    .target(
      name: "API",
      dependencies: [
        .product(name: "ApolloAPI", package: "apollo-ios"),
      ],
      path: "./Sources",
      swiftSettings: [
        .swiftLanguageMode(.v5)
      ]
    ),
  ]
)

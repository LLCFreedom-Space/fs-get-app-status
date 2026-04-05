// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "fs-get-app-status",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "GetAppStatus",
                 targets: ["GetAppStatus"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        // 🖋 Swift ORM (queries, models, and relations) for NoSQL and SQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.5.0"),
        // 🐘 Swift ORM (queries, models, relations, etc) built on PostgreSQL.
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.4.0"),
        // 🐈 MongoDB driver based on Swift NIO.
        .package(url: "https://github.com/orlandos-nl/MongoKitten.git", from: "7.2.0"),
        //  Vapor provider for RedisKit + RedisNIO
        .package(url: "https://github.com/vapor/redis.git", from: "5.0.0-alpha.2.2"),
        // 📄 Swift-DocC plugin for generating documentation.
        .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "GetAppStatus",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Redis", package: "redis"),
                .product(name: "MongoKitten", package: "MongoKitten")
            ]
        ),
        .testTarget(
            name: "GetAppStatusTests",
            dependencies: [
                .target(name: "GetAppStatus"),
                .product(name: "VaporTesting", package: "vapor"),
            ]
        )
    ]
)

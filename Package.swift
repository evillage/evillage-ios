// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "evillage-ios",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "ClangNotifications",
            targets: ["ClangNotifications"]
        ),
    ],
    targets: [
        .target(
            name: "ClangNotifications",
            path: "ClangNotifications",
            exclude: [
                "ClangNotifications.h",
                "Info.plist",
            ]
        ),
    ]
)

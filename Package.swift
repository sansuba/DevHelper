// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DevHelper",
    products: [
        .library(name: "DevHelper", targets: ["DevHelper"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.9.1")
    ],
    targets: [
        .target(name: "DevHelper", dependencies: ["Alamofire"])
    ]
)

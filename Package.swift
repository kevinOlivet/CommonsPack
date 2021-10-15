// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CommonsPack",
    defaultLocalization: "en",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "CommonsPack",
            targets: ["CommonsPack"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.0")),
        .package(url: "https://github.com/Alamofire/AlamofireImage.git", .upToNextMajor(from: "4.2.0")),
        .package(url: "https://github.com/konkab/AlamofireNetworkActivityLogger.git", .upToNextMajor(from: "3.4.0")),
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs.git", .upToNextMajor(from: "9.1.0")),
        .package(url: "https://github.com/jrendel/SwiftKeychainWrapper.git", .upToNextMajor(from: "4.0.0")),
        .package(name: "Lottie", url: "https://github.com/airbnb/lottie-ios.git", from: "3.2.1")
    ],
    targets: [
        .target(
            name: "CommonsPack",
            dependencies: [
                "Alamofire",
                "AlamofireImage",
                "AlamofireNetworkActivityLogger",
                "OHHTTPStubs",
                "SwiftKeychainWrapper",
                "Lottie"
            ],
            resources: [
//                .copy("Resources")
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "CommonsPackTests",
            dependencies: ["CommonsPack"]),
    ]
)

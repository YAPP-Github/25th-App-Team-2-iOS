// swift-tools-version: 5.9
@preconcurrency import PackageDescription

#if TUIST
@preconcurrency import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework 
        productTypes: [:]
    )
#endif

let package = Package(
    name: "TnT",
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.17.0"),
        .package(url: "https://github.com/airbnb/lottie-ios", from: "4.5.0"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk.git", from: "2.20.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.6.3"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.7.0"),
        .package(url: "https://github.com/WenchaoD/FSCalendar.git", from: "2.8.4")
    ]
)

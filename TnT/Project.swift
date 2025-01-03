import ProjectDescription

let project = Project(
    name: "TnT",
    targets: [
        .target(
            name: "TnT",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.TnT",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                ]
            ),
            sources: ["TnT/Sources/**"],
            resources: ["TnT/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "TnTTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.TnTTests",
            infoPlist: .default,
            sources: ["TnT/Tests/**"],
            resources: [],
            dependencies: [.target(name: "TnT")]
        ),
    ]
)

//
//  Target+Templates.swift
//  Packages
//
//  Created by 박서연 on 1/3/25.
//

@preconcurrency import ProjectDescription

public extension Target {
    private static let organizationName = environmentOrganizationName
    private static let destinations = environmentDestinations
    private static let deploymentTargets = environmentDeploymentTargets
    
    static func moduleTarget(
        name: String,
        product: Product = .staticLibrary,
        resources: Bool = false,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return Target.target(
            name: name,
            destinations: destinations,
            product: product,
            bundleId: "com.\(organizationName).\(name)",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: resources ? ["Resources/**"] : nil,
            scripts: [.swiftLint],
            dependencies: dependencies,
            settings: Configuration.defaultSettings()
        )
    }
       
    static func appTarget(
        name: String,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return Target.target(
            name: name,
            destinations: destinations,
            product: .app,
            bundleId: "com.\(name).\(organizationName)",
            deploymentTargets: deploymentTargets,
            infoPlist: .file(path: "Support/Info.plist"),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            //            entitlements: "\(name).entitlements", // 추가 후 주석 해제
            scripts: [.swiftLint],
            dependencies: dependencies,
            settings: Configuration.defaultSettings()
        )
    }
}



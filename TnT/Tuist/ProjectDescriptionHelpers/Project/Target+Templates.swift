//
//  Target+Templates.swift
//  Packages
//
//  Created by 박서연 on 1/3/25.
//

@preconcurrency import ProjectDescription
@preconcurrency import ProjectDescription

public extension Target {
    private static let appName = Environment.appName
    private static let destinations = Environment.destinations
    private static let deploymentTargets = Environment.deploymentTarget
    private static let organizationName = Environment.organizationName
    
    static func staticLibraryTarget(
        name: String,
        resource: Bool = false,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return Target.target(
            name: name,
            destinations: destinations,
            product: .staticLibrary,
            bundleId: "\(organizationName).\(appName).\(name)",
            deploymentTargets: deploymentTargets,
            infoPlist: .file(path: .relativeToRoot("Tuist/Config/Info.plist")),
            sources: ["Sources/**"],
            resources: resource ? ["Resources/**"] : nil,
            scripts: [.swiftLint],
            dependencies: dependencies
        )
    }
    
    static func dynamicLibraryTarget(
        name: String,
        resource: Bool = false,
        dependencies: [TargetDependency] = [],
        mergedBinaryType: MergedBinaryType = .disabled,
        mergeable: Bool = false
    ) -> Target {
        return Target.target(
            name: name,
            destinations: destinations,
            product: .framework,
            bundleId: "\(organizationName).\(appName).\(name)",
            deploymentTargets: deploymentTargets,
            infoPlist: .file(path: .relativeToRoot("Tuist/Config/Info.plist")),
            sources: ["Sources/**"],
            resources: resource ? ["Resources/**"] : nil,
            scripts: [.swiftLint],
            dependencies: dependencies,
            mergedBinaryType: mergedBinaryType,
            mergeable: mergeable
        )
    }
    
    static func appTarget(
        dependencies: [TargetDependency] = []
    ) -> Target {
        return Target.target(
            name: appName,
            destinations: destinations,
            product: .app,
            bundleId: "\(organizationName).\(appName).\(appName)",
            deploymentTargets: deploymentTargets,
            infoPlist: .file(path: .relativeToRoot("Tuist/Config/Info.plist")),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            scripts: [.swiftLint],
            dependencies: dependencies
        )
    }
}

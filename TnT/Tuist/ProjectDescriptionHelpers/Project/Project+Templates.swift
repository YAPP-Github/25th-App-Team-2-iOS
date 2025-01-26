//
//  Project+Templates.swift
//  Packages
//
//  Created by 박서연 on 1/3/25.
//

@preconcurrency import ProjectDescription

public extension Project {
    private static let appName = Environment.appName
    private static let organizationName = Environment.organizationName
    
    static let customOption: Options = .options(
        defaultKnownRegions: ["en", "ko"],
        developmentRegion: "ko"
    )
    
    static func appProject(
        dependencies: [TargetDependency] = []
    ) -> Project {
        return Project(
            name: appName,
            organizationName: organizationName,
            options: customOption,
            settings: Configuration.defaultSettings(),
            targets: [
                Target.appTarget(
                    dependencies: DependencyInformation.dependencies(of: appName)
                )
            ],
            schemes: .app
        )
    }
    
    static func dynamicFrameworkProject(
        name: String,
        resources: Bool,
        dependencies: [TargetDependency] = [],
        packages: [Package] = []
    ) -> Project {
        let debugScheme = Scheme.scheme(
            schemeName: "\(name)Debug",
            targetName: name,
            configurationName: .debug
        )

        let releaseScheme = Scheme.scheme(
            schemeName: "\(name)Release",
            targetName: name,
            configurationName: .release
        )
        
        return Project(
            name: name,
            options: customOption,
            settings: Configuration.defaultSettings(),
            targets: [
                Target.dynamicLibraryTarget(
                    name: name,
                    resource: resources,
                    dependencies: DependencyInformation.dependencies(of: name)
                )
            ],
            schemes: [debugScheme, releaseScheme]
        )
    }
    
    static func staticLibraryProejct(
        name: String,
        resource: Bool,
        dependenceis: [TargetDependency] = []
    ) -> Project {
        let debugScheme = Scheme.scheme(
            schemeName: "\(name)Debug",
            targetName: name,
            configurationName: .debug
        )

        let releaseScheme = Scheme.scheme(
            schemeName: "\(name)Release",
            targetName: name,
            configurationName: .release
        )
        
        return Project(
            name: name,
            organizationName: organizationName,
            options: customOption,
            settings: Configuration.defaultSettings(),
            targets: [
                Target.staticLibraryTarget(
                    name: name,
                    resource: resource,
                    dependencies: DependencyInformation.dependencies(of: name)
                )
            ],
            schemes: [debugScheme, releaseScheme]
        )
    }
}

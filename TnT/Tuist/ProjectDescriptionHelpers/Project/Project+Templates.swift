//
//  Project+Templates.swift
//  Packages
//
//  Created by 박서연 on 1/3/25.
//

@preconcurrency import ProjectDescription

public extension Project {
    private static let appName = environmentName
    private static let organizationName = environmentOrganizationName

    static let customOption: Options = .options(
        defaultKnownRegions: ["en", "ko"],
        developmentRegion: "ko"
    )
    
    static var app: Project {
        return Project(
            name: appName,
            organizationName: organizationName,
            options: customOption,
            settings: Configuration.defaultSettings(),
            targets: .app,
            schemes: .app
        )
    }
    
    static func module(
        name: String,
        options: Options = customOption,
        resources: Bool
    ) -> Project {
        return Project(
            name: name,
            organizationName: organizationName,
            options: options,
            settings: Configuration.defaultSettings(),
            targets: .targets(name: name, resources: resources),
            schemes: [
                .scheme(
                    schemeName: name,
                    targetName: name,
                    configurationName: .debug
                )
            ]
        )
    }
}

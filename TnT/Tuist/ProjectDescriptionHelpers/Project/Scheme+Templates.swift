//
//  Scheme+Templates.swift
//  Packages
//
//  Created by 박서연 on 1/3/25.
//

@preconcurrency import ProjectDescription

extension Array where Element == Scheme {
    static var app: [Scheme] {
        let name = environmentName
        let deployTargets: [ConfigurationName] = [.debug, .release]
        
        return deployTargets.map {
            return .scheme(
                schemeName: "\(name)-\($0.rawValue)",
                targetName: name,
                configurationName: .configuration($0.rawValue),
                isAppTarget: true
            )
        }
    }
}

extension Scheme {
    static func scheme(
        schemeName: String,
        targetName: String,
        configurationName: ConfigurationName,
        isAppTarget: Bool = false
    ) -> Scheme {
        var testAction: TestAction?
        if !isAppTarget {
            testAction = .targets(
                ["\(targetName)Tests"],
                configuration: configurationName,
                options: .options(coverage: true, codeCoverageTargets: ["\(targetName)"])
            )
        }
        
        let isRelease = configurationName == .release
        return Scheme.scheme(
            name: schemeName,
            buildAction: .buildAction(targets: ["\(targetName)"]),
            testAction: testAction,
            runAction: .runAction(configuration: configurationName),
            archiveAction: .archiveAction(configuration: isRelease ? .release : configurationName),
            profileAction: .profileAction(configuration: isRelease ? .release : configurationName),
            analyzeAction: .analyzeAction(configuration: configurationName)
        )
    }
}

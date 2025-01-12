//
//  Dependency+Teplates.swift
//  Packages
//
//  Created by 박서연 on 1/3/25.
//

@preconcurrency import ProjectDescription

extension Array where Element == Target {
    static var app: [Target] {
        let name = environmentName
        return [
            Target.appTarget(name: name, dependencies: .dependencies(of: name))
        ]
    }
    
    static func targets(name: String, resources: Bool) -> [Target] {
        let target = Target.moduleTarget(name: name, product: .staticLibrary, resources: resources, dependencies: .dependencies(of: name))

        return [target]
    }
}

public extension Array where Element == TargetDependency {
    static func dependencies(of name: String) -> [TargetDependency] {
        guard let name = DependencyInformation(rawValue: name) else { return [] }
        guard let modules: [DependencyInformation] = dependencyInfo[name] else { return [] }
        
        return modules.map { module in
            let name = module.rawValue
            
            if externalDependency.contains(module) {
                return .external(name: name)
            } else {
                return .project(target: name, path: .relativeToRoot("Projects/\(name)"))
            }
        }
    }
}

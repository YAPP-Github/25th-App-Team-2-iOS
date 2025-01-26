//
//  DependencyInformation.swift
//  Packages
//
//  Created by 박서연 on 1/3/25.
//

@preconcurrency import ProjectDescription

let dependencyInfo: [DependencyInformation: [DependencyInformation]] = [
    .TnTApp: [.Presentation, .Data],
    .Presentation: [.DesignSystem, .Domain, .ComposableArchitecture],
    .Domain: [.SwiftDepedencies],
    .Data: [.Domain, .KakaoSDKUser, .SwiftDepedencies],
    .DesignSystem: [.Lottie],
]

public enum DependencyInformation: String, CaseIterable, Sendable {
    case TnTApp = "TnTApp"
    case Presentation = "Presentation"
    case Domain = "Domain"
    case Data = "Data"
    case DesignSystem = "DesignSystem"
    case Lottie = "Lottie"
    case ComposableArchitecture = "ComposableArchitecture"
    case KakaoSDKUser = "KakaoSDKUser"
    case SwiftDepedencies = "Dependencies"
}

public extension DependencyInformation {
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

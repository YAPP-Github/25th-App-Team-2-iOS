//
//  DependencyInformation.swift
//  Packages
//
//  Created by 박서연 on 1/3/25.
//

@preconcurrency import ProjectDescription

let dependencyInfo: [DependencyInformation: [DependencyInformation]] = [
    .TnTApp: [.Presentation, .Data, .Domain, .ComposableArchitecture],
    .Presentation: [.DesignSystem, .ComposableArchitecture, .Lottie],
    .Domain: [.DI, .SwiftDepedencies],
    .Data: [.Domain, .KakaoSDKUser],
    .DesignSystem: [.ComposableArchitecture],
    .DI: []
]

public enum DependencyInformation: String, CaseIterable, Sendable {
    case TnTApp = "TnTApp"
    case Presentation = "Presentation"
    case Domain = "Domain"
    case Data = "Data"
    case DI = "DI"
    case DesignSystem = "DesignSystem"
    case Lottie = "Lottie"
    case ComposableArchitecture = "ComposableArchitecture"
    case KakaoSDKUser = "KakaoSDKUser"
    case SwiftDepedencies = "Dependencies"
}

extension DependencyInformation {
    public func setDependency(module: DependencyInformation) -> TargetDependency {
        switch self {
        case .TnTApp:
            return .project(target: self.rawValue, path: "Projects/TnTApp")
        case .Presentation:
            return .project(target: self.rawValue, path: "Projects/Presentation")
        case .Domain:
            return .project(target: self.rawValue, path: "Projects/Domain")
        case .Data:
            return .project(target: self.rawValue, path: "Projects/Data")
        case .DI:
            return .project(target: self.rawValue, path: "Projects/DI")
        case .DesignSystem:
            return .project(target: self.rawValue, path: "Projects/DesignSystem")
        default:
            return .project(target: "none", path: "")
        }
    }
}

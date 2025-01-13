//
//  Environment.swift
//  Packages
//
//  Created by 박서연 on 1/3/25.
//

@preconcurrency import ProjectDescription

public let environmentName: String = "TnTApp"
public let environmentOrganizationName: String = "yapp25thTeamTnT"
public let environmentDeploymentTargets: DeploymentTargets = .iOS("17.0")
public let environmentPlatform: Platform = .iOS
public let environmentDestinations: Destinations = [.iPhone]

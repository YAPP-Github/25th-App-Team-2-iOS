//
//  Project.swift
//  Packages
//
//  Created by 박서연 on 1/3/25.
//

@preconcurrency import ProjectDescription
@preconcurrency import ProjectDescriptionHelpers

let project = Project.dynamicFrameworkProject(name: "DesignSystem", resources: true)

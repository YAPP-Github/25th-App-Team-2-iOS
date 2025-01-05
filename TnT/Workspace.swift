//
//  Workspace.swift
//  Packages
//
//  Created by 박서연 on 1/4/25.
//

@preconcurrency import ProjectDescription
@preconcurrency import ProjectDescriptionHelpers

let workspace = Workspace(
    name: "TNT",
    projects: [
        "Projects/TnTApp",
        "Projects/Presentation",
        "Projects/DesignSystem",
        "Projects/DI",
        "Projects/Domain",
        "Projects/Data"
    ]
)

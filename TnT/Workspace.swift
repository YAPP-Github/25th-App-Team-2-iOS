//
//  Workspace.swift
//  Packages
//
//  Created by 박서연 on 1/4/25.
//

import ProjectDescription

let workspace = Workspace(
    name: "TNT",
    projects: [
        "Projects/TnTApp",
        "Projects/Presentation",
        "Projects/DesignSystem",
        "Projects/Domain",
        "Projects/Data"
    ],
    generationOptions: .options(
      autogeneratedWorkspaceSchemes: .enabled()
    )
)

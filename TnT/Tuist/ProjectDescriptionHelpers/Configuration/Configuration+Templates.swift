//
//  Configuration+Templates.swift
//  Packages
//
//  Created by 박서연 on 1/3/25.
//

@preconcurrency import ProjectDescription

public extension Configuration {
    static func defaultSettings() -> Settings {
        return Settings.settings(
            base: ["OTHER_LDFLAGS": ["-ObjC"]],
            configurations: [
                .debug(name: .debug, xcconfig: .relativeToRoot("Projects/TnTApp/Config/Secrets.xcconfig")),
                .release(name: .release, xcconfig: .relativeToRoot("Projects/TnTApp/Config/Secrets.xcconfig")),
            ],
            defaultSettings: DefaultSettings.recommended
        )
    }
}



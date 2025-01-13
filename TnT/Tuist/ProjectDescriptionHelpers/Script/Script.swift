//
//  Script.swift
//  DIManifests
//
//  Created by 박서연 on 1/5/25.
//

import ProjectDescription

import ProjectDescription

public extension TargetScript {
    static let swiftLint = TargetScript.pre(script: """
    if [ "${ENABLE_LINT}" = "NO" ] ; then
        echo "LINT DISABLED!"
        exit
    fi

    # 프로젝트 루트 경로 계산
    ROOT_DIR=$(git rev-parse --show-toplevel)
    echo "ROOT_DIR: ${ROOT_DIR}"

    if test -d "/opt/homebrew/bin/"; then
        PATH="/opt/homebrew/bin/:${PATH}"
    fi

    export PATH

    if which swiftlint > /dev/null; then
        swiftlint --config "${ROOT_DIR}/TnT/Tuist/Config/.swiftlint.yml"
    else
        echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
    fi
    """, name: "SwiftLint")
}

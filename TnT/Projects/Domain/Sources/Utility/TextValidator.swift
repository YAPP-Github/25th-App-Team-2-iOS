//
//  StringValidator.swift
//  Domain
//
//  Created by 박민서 on 1/17/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

public struct UserPolicyValidator {
    /// 입력값이 `UserPolicy.allowedCharactersRegex`에 맞는지 검사하는 함수
    public static func isValidName(_ name: String) -> Bool {
        let pattern = UserPolicy.allowedCharactersRegex
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        let range = NSRange(location: 0, length: name.utf16.count)
        return regex.firstMatch(in: name, options: [], range: range) != nil
    }
}

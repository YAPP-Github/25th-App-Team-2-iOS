//
//  TextValidator.swift
//  Domain
//
//  Created by 박민서 on 1/17/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

enum TextValidator {
    /// 사용자가 입력할 때 즉각적인 유효성 검사를 수행하는 함수
    /// - Parameters:
    ///   - text: 검증할 문자열
    ///   - maxLength: 최대 입력 가능 길이
    ///   - regexPattern: 허용할 문자에 대한 정규식
    /// - Returns: 입력이 유효한지 여부 (`true` = 허용, `false` = 입력 불가)
    static func isValidInput(
        _ text: String,
        maxLength: Int,
        regexPattern: String
    ) -> Bool {
        guard text.count <= maxLength,
              let regex = try? NSRegularExpression(pattern: regexPattern) else {
            return false
        }
        
        let range: NSRange = .init(location: 0, length: text.utf16.count)
        return regex.firstMatch(in: text, options: [], range: range) != nil
    }
    
    /// 문자열이 특정 날짜 포맷에 맞는 유효한 날짜인지 확인
    /// - Parameters:
    ///   - text: 검증할 문자열 (날짜)
    ///   - format: 검증할 날짜 포맷 (`TDateFormat`)
    /// - Returns: 유효한 날짜면 `true`, 아니면 `false`
    static func isValidDate(text: String, format: TDateFormat) -> Bool {
        return text.toDate(format: format) != nil
    }
}

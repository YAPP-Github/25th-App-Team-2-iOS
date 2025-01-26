//
//  PolicyInputInfo.swift
//  Domain
//
//  Created by 박민서 on 1/27/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

/// 정책 중 입력값에 관련한 정책 정보
struct PolicyInputInfo {
    /// 입력 값이 유효한지 검증하는 함수
    public let textValidation: (String) -> Bool
    /// 필수 입력 여부
    public let isRequired: Bool
}

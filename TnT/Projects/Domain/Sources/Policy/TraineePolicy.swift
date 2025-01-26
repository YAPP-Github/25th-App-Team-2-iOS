//
//  TraineePolicy.swift
//  Domain
//
//  Created by 박민서 on 1/27/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

struct TraineePolicy {
    /// PT 시작일 입력 검증 (YYYY/MM/DD 형식)
    static let startDateInput: PolicyInputInfo = .init(
        textValidation: { TextValidator.isValidDate(text: $0, format: .yyyyMMddSlash) },
        isRequired: false
    )
    
    /// 초대코드 입력 검증
    static let invitationInput: PolicyInputInfo = .init(
        textValidation: { TextValidator.isValidInput($0, maxLength: 8, regexPattern: "^[A-Z0-9]{8}$") },
        isRequired: true
    )
    
    /// PT 횟수 입력 검증
    static let ptCountInput: PolicyInputInfo = .init(
        textValidation: {
            guard let value = Int($0) else { return false }
            return (0...99).contains(value)
        },
        isRequired: true
    )
}

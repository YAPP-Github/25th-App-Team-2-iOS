//
//  UserPolicy.swift
//  Domain
//
//  Created by 박민서 on 1/17/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

struct UserPolicy {
    /// 사용자 이름 최대 길이 제한 (공백 포함)
    public static let maxNameLength: Int = 15
    
    /// 사용자 이름 가능 문자: 한글/영어/공백만 허용 (특수문자 불가)
    public static let allowedCharactersRegex = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z ]*$"
    
    /// 생년월일 입력 검증 (YYYY/MM/DD 형식)
    public static let birthDateInput: InputInfo = .init(
        textValidation: { TextValidator.isValidDate(text: $0, format: .yyyyMMddSlash) },
        isRequired: false
    )
    
    /// 키 입력 검증 (정수 3자리, 필수)
    public static let heightInput: InputInfo = .init(
        textValidation: { TextValidator.isValidInput($0, maxLength: 3, regexPattern: #"^\d{3}$"#) },
        isRequired: true
    )
    
    /// 몸무게 입력 검증 (정수 3자리 + 소수점 1자리, 필수)
    /// 정수 최소 2자리 이상, 소수점 1자리까지만
    public static let weightInput: InputInfo = .init(
        textValidation: { TextValidator.isValidInput($0, maxLength: 5, regexPattern: #"^\d{2,3}(\.\d{1})?$"#) },
        isRequired: true
    )
    
    /// 주의사항 최대 길이 제한 (공백 포함)
    public static let maxPrecautionLength: Int = 100
    
    /// 주의사항 입력 검증 (100자 제한, 외 제한 없음. 옵션)
    public static let precautionInput: InputInfo = .init(
        textValidation: { $0.count <= maxPrecautionLength },
        isRequired: false
    )
}

extension UserPolicy {
    struct InputInfo {
        /// 입력 값이 유효한지 검증하는 함수
        public let textValidation: (String) -> Bool
        /// 필수 입력 여부
        public let isRequired: Bool
    }
}

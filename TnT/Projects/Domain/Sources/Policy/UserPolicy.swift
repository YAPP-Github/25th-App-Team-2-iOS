//
//  UserPolicy.swift
//  Domain
//
//  Created by 박민서 on 1/17/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

public struct UserPolicy {
    /// 사용자 이름 최대 길이 제한 (공백 포함)
    public static let maxNameLength: Int = 15
    
    /// 사용자 이름 가능 문자: 한글/영어/공백만 허용 (특수문자 불가)
    public static let allowedCharactersRegex = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z ]*$"
}

//
//  UserTypeText.swift
//  Presentation
//
//  Created by 박민서 on 1/25/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Domain

public extension UserType {
    /// 유저 타입을 한글로 변환하여 반환
    var koreanName: String {
        switch self {
        case .trainer:
            return "트레이너"
        case .trainee:
            return "트레이니"
        }
    }
}

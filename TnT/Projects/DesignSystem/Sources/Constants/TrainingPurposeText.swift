//
//  TrainingPurposeText.swift
//  DesignSystem
//
//  Created by 박민서 on 1/25/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Domain

public extension TrainingPurpose {
    /// 운동 목적을 한글로 변환하여 반환
    var koreanName: String {
        switch self {
        case .loseWeight:
            return "체중 감량"
        case .gainMuscle:
            return "근력 향상"
        case .healthWellness:
            return "건강 관리"
        case .flexibilityImprovement:
            return "유연성 향상"
        case .bodyProfile:
            return "바디프로필"
        case .postureCorrection:
            return "자세 교정"
        }
    }
}

//
//  TrainingPurpose.swift
//  Domain
//
//  Created by 박민서 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 사용자의 운동 목적을 정의하는 열거형
public enum TrainingPurpose: Sendable, CaseIterable {
    /// 체중 감량
    case loseWeight
    /// 근력 향상
    case gainMuscle
    /// 건강 관리
    case healthWellness
    /// 유연성 향상
    case flexibilityImprovement
    /// 바디프로필 준비
    case bodyProfile
    /// 자세 교정
    case postureCorrection
}

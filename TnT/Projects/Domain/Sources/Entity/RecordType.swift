//
//  RecordType.swift
//  Domain
//
//  Created by 박민서 on 1/29/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

/// 앱에서 존재하는 기록 유형을 정의한 열거형
public enum RecordType: Sendable, Equatable {
    /// n회차 수업
    case session(count: Int)
    /// 운동
    case workout(type: WorkoutType)
    /// 식단
    case diet(type: DietType)
}

public extension RecordType {
    /// 기록 타입을 한글로 변환하여 반환
    var koreanName: String {
        switch self {
        case .session(let count):
            return "\(count)회차 수업"
        case .workout(let type):
            return type.koreanName
        case .diet(let type):
            return type.koreanName
        }
    }
}

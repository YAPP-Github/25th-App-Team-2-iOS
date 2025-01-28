//
//  WorkoutType.swift
//  Domain
//
//  Created by 박민서 on 1/29/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 앱에서 존재하는 운동 유형을 정의한 열거형
public enum WorkoutType: Sendable {
    case upperBody
    case lowerBody
    case back
    case shoulder
    case cardio
    
    /// 운동 유형을 한글로 변환하여 반환
    var koreanName: String {
        switch self {
        case .upperBody: return "상체 운동"
        case .lowerBody: return "하체 운동"
        case .back: return "등 운동"
        case .shoulder: return "어깨 운동"
        case .cardio: return "유산소"
        }
    }
}

//
//  DietType.swift
//  Domain
//
//  Created by 박민서 on 1/29/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 앱에서 존재하는 식단 유형을 정의한 열거형
public enum DietType: String, Sendable, CaseIterable {
    case breakfast
    case lunch
    case dinner
    case snack
    
    /// 식사 유형을 한글로 변환하여 반환
    public var koreanName: String {
        switch self {
        case .breakfast: return "아침"
        case .lunch: return "점심"
        case .dinner: return "저녁"
        case .snack: return "간식"
        }
    }
}

//
//  MealType.swift
//  Presentation
//
//  Created by 박민서 on 1/29/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Domain
import DesignSystem

extension DietType {
    /// 해당 식단을 표시하는 이모지 입니다
    var emoji: String {
        switch self {
        case .breakfast:
            "🌞"
        case .lunch:
            "⛅"
        case .dinner:
            "🌙"
        case .snack:
            "🍰"
        }
    }
}

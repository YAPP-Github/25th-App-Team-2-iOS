//
//  UnitText.swift
//  DesignSystem
//
//  Created by 박민서 on 1/25/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 키 및 몸무게 단위를 관리하는 열거형
public enum UnitText {
    /// 키 단위
    case height
    /// 몸무게 단위
    case weight
    
    /// 해당 항목의 한국 단위 반환
    public var koreaUnit: String {
        switch self {
        case .height:
            return "cm"
        case .weight:
            return "kg"
        }
    }
}

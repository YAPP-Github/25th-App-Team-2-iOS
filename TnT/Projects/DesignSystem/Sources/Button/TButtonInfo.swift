//
//  TButtonInfo.swift
//  DesignSystem
//
//  Created by 박서연 on 1/15/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// 버튼의 상태를 정의하는 열거형
/// - `default`: 기본 스타일 상태
/// - `disable`: 비활성화 상태
public enum ButtonState {
    case `default`(DefaultStyle)
    case disable(DisableStyle)
}

/// 기본 스타일을 정의하는 열거형
/// 버튼의 다양한 기본 스타일과 그에 따른 색상 속성을 정의
public enum DefaultStyle {
    case primaryDefault
    case grayDefault
    case outlineDefault
    case redDefault
    
    /// 버튼 배경 색상
    var backgound: Color {
        switch self {
        case .primaryDefault:
            return .neutral900
        case .grayDefault:
            return .neutral100
        case .outlineDefault:
            return .clear
        case .redDefault:
            return .red50
        }
    }
    
    /// 버튼 텍스트 색상
    var textColor: Color {
        switch self {
        case .primaryDefault:
            return .neutral50
        case .grayDefault:
            return .neutral500
        case .outlineDefault:
            return .neutral500
        case .redDefault:
            return .red600
        }
    }
    
    /// 버튼 외곽선 색상
    var borderColor: Color {
        switch self {
        case .primaryDefault, .grayDefault:
            return .clear
        case .outlineDefault:
            return .neutral300
        case .redDefault:
            return .red400
        }
    }
}

/// 비활성화 상태 스타일을 정의하는 열거형
/// 버튼의 비활성화 상태에서 색상 속성을 정의
public enum DisableStyle {
    case grayDisable // primaryDefault, grayDefault와 매칭되는 비활성화 스타일
    case outlineDisable // outlineDefault, redDefault와 매칭되는 비활성화 스타일
    
    /// 버튼 배경 색상
    var background: Color {
        switch self {
        case .grayDisable:
            return .neutral200
        case .outlineDisable:
            return .clear
        }
    }
    
    /// 버튼 텍스트 색상
    var textColor: Color {
        switch self {
        case .grayDisable:
            return .common0
        case .outlineDisable:
            return .neutral300
        }
    }
    
    /// 버튼 외곽선 색상
    var borderColor: Color {
        switch self {
        case .grayDisable:
            return .clear
        case .outlineDisable:
            return .neutral300
        }
    }
}

/// 버튼의 크기별 구성 속성을 정의하는 열거형
/// 버튼의 코너 반경, 세로 크기, 글꼴 스타일을 정의
public enum ButtonConfiguration {
    case xLarge
    case large
    case medium
    case small
    case xSmall
    
    /// 버튼 코너 반경 (radius)
    var radius: CGFloat {
        switch self {
        case .xLarge, .large:
            return 16
        case .medium:
            return 12
        case .small:
            return 8
        case .xSmall:
            return 6
        }
    }
    
    /// 버튼 세로 크기 (vertical padding)
    var verticalSize: CGFloat {
        switch self {
        case .xLarge:
            return 20
        case .large:
            return 16
        case .medium:
            return 12
        case .small:
            return 7
        case .xSmall:
            return 3
        }
    }
    
    /// 버튼 글꼴 스타일
    var font: Typography.FontStyle {
        switch self {
        case .xLarge:
            return .body1Semibold
        case .large, .medium:
            return .body1Medium
        case .small:
            return .label1Medium
        case .xSmall:
            return .label2Medium
        }
    }
}

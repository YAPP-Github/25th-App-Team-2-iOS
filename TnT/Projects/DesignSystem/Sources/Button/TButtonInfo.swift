//
//  TButtonInfo.swift
//  DesignSystem
//
//  Created by 박서연 on 1/15/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// 버튼의 이미지를 위한 구조체
public struct ButtonImage {
    public let resource: ImageResource
    public let size: CGFloat
    public let type: ButtonPostiton?
    
    public init(
        resource: ImageResource,
        size: CGFloat,
        type: ButtonPostiton? = nil
    ) {
        self.resource = resource
        self.size = size
        self.type = type
    }
}

/// 버튼의 상태를 정의하는 열거형
/// - `default`: 기본 스타일 상태
/// - `disable`: 비활성화 상태
public enum ButtonState {
    case `default`(DefaultStyle)
    case disable(DefaultStyle)
}

/// 기본 스타일을 정의하는 열거형
/// 버튼의 다양한 기본 스타일과 그에 따른 색상 속성을 정의
public enum DefaultStyle {
    case primary(isEnabled: Bool)
    case gray(isEnabled: Bool)
    case outline(isEnabled: Bool)
    case red(isEnabled: Bool)
    
    /// 버튼 배경 색상
    var backgound: Color {
        switch self {
        case .primary(let isEnabled):
            return isEnabled ? .neutral900 : .neutral200
        case .gray(let isEnabled):
            return isEnabled ? .neutral100 : .neutral200
        case .outline(let isEnabled):
            return isEnabled ? .neutral300 : .clear
        case .red(let isEnabled):
            return isEnabled ? .red400 : .clear
        }
    }
    
    /// 버튼 텍스트 색상
    var textColor: Color {
        switch self {
        case .primary(let isEnabled):
            return isEnabled ? .neutral50 : .neutral50
        case .gray(let isEnabled):
            return isEnabled ? .neutral500 : .neutral50
        case .outline(let isEnabled):
            return isEnabled ? .neutral300 : .neutral500
        case .red(let isEnabled):
            return isEnabled ? .red600 : .neutral300
        }
    }
    
    /// 버튼 외곽선 색상
    var borderColor: Color {
        switch self {
        case .primary(let isEnabled):
            return isEnabled ? .clear : .clear
        case .gray(let isEnabled):
            return isEnabled ? .clear : .clear
        case .outline(let isEnabled):
            return isEnabled ? .neutral300 : .neutral300
        case .red(let isEnabled):
            return isEnabled ? .red400 : .neutral300
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
    
    var horizontalSize: CGFloat {
        switch self {
        case .xLarge, .large, .medium, .small, .xSmall:
            return 20
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

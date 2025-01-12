//
//  Font+DesignSystem.swift
//  DesignSystem
//
//  Created by 박민서 on 1/12/25.
//  Copyright © 2025 yapp25-app2team. All rights reserved.
//

import SwiftUI

/// 앱에서 사용할 폰트와 스타일을 관리
public struct Typography {
    
    /// Pretendard 폰트의 굵기와 커스텀 폰트를 생성
    public struct Pretendard {
        /// Pretendard 폰트의 굵기(enum) 정의
        public enum Weight {
            case thin, extraLight, light, regular, medium, semibold, bold, extrabold, black
            
            public var name: String {
                switch self {
                case .thin: return "Pretendard-Thin"
                case .extraLight: return "Pretendard-ExtraLight"
                case .light: return "Pretendard-Light"
                case .regular: return "Pretendard-Regular"
                case .medium: return "Pretendard-Medium"
                case .semibold: return "Pretendard-SemiBold"
                case .bold: return "Pretendard-Bold"
                case .extrabold: return "Pretendard-ExtraBold"
                case .black: return "Pretendard-Black"
                }
            }
        }
        
        /// 주어진 Weight와 크기로 커스텀 폰트를 생성합니다.
        /// - Parameters:
        ///   - weight: Pretendard의 폰트 굵기
        ///   - size: 폰트 크기
        /// - Returns: SwiftUI Font 객체
        public static func customFont(_ weight: Pretendard.Weight, size: CGFloat) -> Font {
            return Font.custom(weight.name, size: size)
        }
    }
    
    /// 폰트, 줄 높이, 줄 간격, 자간 등을 포함한 스타일 정의를 위한 구조체입니다.
    public struct FontStyle {
        public let font: Font
        public let lineHeight: CGFloat
        public let lineSpacing: CGFloat
        public let letterSpacing: CGFloat
        
        /// 주어진 Weight, 크기, 줄 높이 배율, 자간으로 FontStyle을 생성합니다.
        /// - Parameters:
        ///   - weight: Pretendard 폰트의 굵기
        ///   - size: 폰트 크기
        ///   - lineHeightMultiplier: 줄 높이 배율 (CGFloat)
        ///   - letterSpacing: 자간 (CGFloat)
        init(_ weight: Pretendard.Weight, size: CGFloat, lineHeightMultiplier: CGFloat, letterSpacing: CGFloat) {
            self.font = Pretendard.customFont(weight, size: size)
            self.lineHeight = size * lineHeightMultiplier
            self.lineSpacing = (size * lineHeightMultiplier) - size
            self.letterSpacing = letterSpacing
        }
    }
}

/// 앱에서 사용할 기본적인 폰트 스타일을 정의합니다.
public extension Typography.FontStyle {
    // Heading Styles
    static let heading1: Typography.FontStyle = Typography.FontStyle(.bold, size: 28, lineHeightMultiplier: 1.4, letterSpacing: -0.02)
    static let heading2: Typography.FontStyle = Typography.FontStyle(.bold, size: 24, lineHeightMultiplier: 1.5, letterSpacing: -0.02)
    static let heading3: Typography.FontStyle = Typography.FontStyle(.bold, size: 20, lineHeightMultiplier: 1.5, letterSpacing: -0.02)
    static let heading4: Typography.FontStyle = Typography.FontStyle(.bold, size: 18, lineHeightMultiplier: 1.5, letterSpacing: -0.02)
    
    // Body Styles
    static let body1Bold: Typography.FontStyle = Typography.FontStyle(.bold, size: 16, lineHeightMultiplier: 1.5, letterSpacing: -0.02)
    static let body1Semibold: Typography.FontStyle = Typography.FontStyle(.semibold, size: 16, lineHeightMultiplier: 1.5, letterSpacing: -0.02)
    static let body1Medium: Typography.FontStyle = Typography.FontStyle(.medium, size: 16, lineHeightMultiplier: 1.6, letterSpacing: -0.02)
    static let body2Bold: Typography.FontStyle = Typography.FontStyle(.bold, size: 15, lineHeightMultiplier: 1.5, letterSpacing: -0.02)
    static let body2Medium: Typography.FontStyle = Typography.FontStyle(.medium, size: 15, lineHeightMultiplier: 1.5, letterSpacing: -0.02)
    
    // Label Styles
    static let label1Bold: Typography.FontStyle = Typography.FontStyle(.bold, size: 13, lineHeightMultiplier: 1.3, letterSpacing: -0.02)
    static let label1Medium: Typography.FontStyle = Typography.FontStyle(.medium, size: 13, lineHeightMultiplier: 1.5, letterSpacing: -0.02)
    static let label2Medium: Typography.FontStyle = Typography.FontStyle(.medium, size: 12, lineHeightMultiplier: 1.5, letterSpacing: -0.02)
    
    // Caption Styles
    static let caption1: Typography.FontStyle = Typography.FontStyle(.medium, size: 11, lineHeightMultiplier: 1.3, letterSpacing: -0.02)
}

/// 텍스트에 스타일을 적용하기 위한 ViewModifier입니다.
struct TypographyModifier: ViewModifier {
    let style: Typography.FontStyle

    func body(content: Content) -> some View {
        content
            .font(style.font)
            .lineSpacing(style.lineSpacing)
            .kerning(style.letterSpacing)
    }
}

/// Typography.FontStyle을 쉽게 적용할 수 있도록 도와줍니다.
public extension View {
    /// Typography.FontStyle을 적용합니다.
    /// - Parameter style: 적용할 Typography.FontStyle
    /// - Returns: 스타일이 적용된 View
    func typographyStyle(_ style: Typography.FontStyle) -> some View {
        self.modifier(TypographyModifier(style: style))
    }
}

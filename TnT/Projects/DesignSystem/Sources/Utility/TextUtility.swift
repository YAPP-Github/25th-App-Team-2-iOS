//
//  TextUtility.swift
//  DesignSystem
//
//  Created by 박민서 on 1/15/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import UIKit

public struct TextUtility {
    /// 주어진 텍스트와 스타일을 기준으로 텍스트 높이를 계산합니다.
    ///
    /// 이 함수는 `NSTextStorage`, `NSLayoutManager`, `NSTextContainer`를 사용하여 텍스트 렌더링의 실제 높이를 계산합니다.
    /// 텍스트가 주어진 너비를 초과할 경우 줄바꿈과 스타일을 고려하여 계산된 높이를 반환합니다.
    ///
    /// - Parameters:
    ///   - boxWidth: 텍스트가 렌더링될 컨테이너의 가로 길이. (최대 너비)
    ///   - text: 높이를 계산할 텍스트 문자열.
    ///   - style: `Typography.FontStyle`로 정의된 폰트, 줄 간격, 자간 등의 스타일.
    /// - Returns: 주어진 스타일로 렌더링된 텍스트의 높이 (CGFloat).
    static func calculateTextHeight(
        boxWidth: CGFloat,
        text: String,
        style: Typography.FontStyle
    ) -> CGFloat {
        // 1. 텍스트 렌더링을 위한 핵심 클래스 설정
        let textStorage: NSTextStorage = NSTextStorage(string: text)
        let textContainer: NSTextContainer = NSTextContainer(size: CGSize(width: boxWidth, height: .greatestFiniteMagnitude))
        let layoutManager: NSLayoutManager = NSLayoutManager()
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // 2. 텍스트 스타일 지정
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = style.lineSpacing
        paragraphStyle.alignment = .left
        
        textStorage.addAttributes([
            .font: style.uiFont,
            .paragraphStyle: paragraphStyle,
            .kern: style.letterSpacing
        ], range: NSRange(location: 0, length: text.count))
        
        // 3. 텍스트 높이 계산
        let estimatedHeight: CGFloat = layoutManager.usedRect(for: textContainer).height
        return estimatedHeight
    }
}

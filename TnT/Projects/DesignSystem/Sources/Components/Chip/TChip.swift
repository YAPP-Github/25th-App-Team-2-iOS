//
//  TChip.swift
//  DesignSystem
//
//  Created by 박민서 on 1/29/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// 앱 전반적으로 사용되는 태그 또는 뱃지 스타일의 UI 컴포넌트입니다
public struct TChip: View {
    /// 좌측 이모지 아이콘
    private let leadingEmoji: String?
    /// 칩 내부 텍스트
    private let title: String
    /// 칩 스타일
    private let style: Style
    
    /// TChip 초기화 메서드
    /// - Parameters:
    ///   - leadingEmoji: 앞에 표시할 이모지 (기본값: `nil`)
    ///   - title: 칩 내부 텍스트
    ///   - style: 칩 스타일 (`blue` 또는 `pink`)
    public init(
        leadingEmoji: String? = nil,
        title: String,
        style: Style
    ) {
        self.leadingEmoji = leadingEmoji
        self.title = title
        self.style = style
    }
    
    public var body: some View {
        HStack(spacing: 2) {
            if let leadingEmoji {
                Text(leadingEmoji)
                    .typographyStyle(.label1Bold)
            }
            Text(title)
                .typographyStyle(.label1Bold, with: style.textColor)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(style.backgroundColor)
        .clipShape(.capsule)
    }
}

public extension TChip {
    enum Style {
        case blue
        case pink
        
        var textColor: Color {
            switch self {
            case .blue:
                return Color.blue800
            case .pink:
                return Color.pink800
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .blue:
                return Color.blue100
            case .pink:
                return Color.pink100
            }
        }
    }
}

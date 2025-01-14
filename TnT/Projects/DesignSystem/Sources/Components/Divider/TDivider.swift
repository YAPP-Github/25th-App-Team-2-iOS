//
//  TDivider.swift
//  DesignSystem
//
//  Created by 박민서 on 1/14/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// TnT 앱 내에서 전반적으로 사용되는 커스텀 디바이더입니다
public struct TDivider: View {
    /// Divider 높이
    let height: CGFloat
    /// Divider 컬러
    let color: Color
    
    /// - Parameters:
    ///   - height: Divider의 두께 (기본값: `1`)
    ///   - color: Divider의 색상
    public init(height: CGFloat = 1, color: Color) {
        self.height = height
        self.color = color
    }
    
    public var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: height)
    }
}

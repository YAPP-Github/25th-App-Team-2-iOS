//
//  TToggleStyle.swift
//  DesignSystem
//
//  Created by 박민서 on 1/15/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// TToggleStyle: ViewModifier
/// SwiftUI의 `Toggle`에 TnT 스타일을 적용하기 위한 커스텀 ViewModifier입니다.
/// 기본 크기와 토글 스타일을 설정하여 재사용 가능한 스타일링을 제공합니다.
struct TToggleStyle: ViewModifier {
    /// 기본 토글 크기
    static let defaultSize: CGSize = .init(width: 44, height: 24)
    
    /// `ViewModifier`가 적용된 뷰의 구성
    /// - Parameter content: 스타일이 적용될 뷰
    /// - Returns: TnT 스타일이 적용된 뷰
    func body(content: Content) -> some View {
        content
            .toggleStyle(SwitchToggleStyle(tint: .red500))
            .labelsHidden()
            .frame(width: TToggleStyle.defaultSize.width, height: TToggleStyle.defaultSize.height)
    }
}

/// Toggle 확장: TnT 스타일 적용
public extension Toggle {
    /// SwiftUI의 기본 `Toggle`에 TnT 스타일을 적용합니다.
    func applyTToggleStyle() -> some View {
        self.modifier(TToggleStyle())
    }
}

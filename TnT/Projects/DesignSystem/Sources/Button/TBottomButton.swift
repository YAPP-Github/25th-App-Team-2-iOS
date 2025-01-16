//
//  TBottomButton.swift
//  DesignSystem
//
//  Created by 박서연 on 1/15/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// TnT 앱 내에서 사용되는 하단 고정형 버튼 컴포넌트입니다
public struct TBottomButton: View {
    /// 버튼의 제목 텍스트
    public let title: String
    
    /// 버튼이 탭되었을 때 실행할 동작 (옵셔널)
    public var action: (() -> Void)
    
    /// TBottomButton 초기화 메서드
    /// - Parameters:
    ///   - title: 버튼에 표시할 제목
    ///   - action: 버튼 탭 시 실행할 동작 (옵셔널)
    public init(
        title: String,
        action: (@escaping () -> Void)
    ) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        Button(title) {
            action()
        }
        .typographyStyle(.heading4, with: .neutral50)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .ignoresSafeArea()
    }
}

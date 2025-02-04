//
//  TToastView.swift
//  DesignSystem
//
//  Created by 박민서 on 2/3/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// 앱 전반적으로 사용되는 토스트 메시지 뷰
/// - 짧은 시간 동안 하단에 나타났다가 사라지는 UI 컴포넌트.
public struct TToastView<LeftView: View>: View {
    /// 토스트 메세지
    private let message: String
    /// 토스트 좌측 뷰
    private let leftView: () -> LeftView

    /// TToastView 초기화 메서드
    /// - Parameters:
    ///   - message: 표시할 메시지
    ///   - leftView: 좌측 아이콘 또는 커스텀 뷰를 반환하는 클로저
    public init(message: String, leftView: @escaping () -> LeftView) {
        self.message = message
        self.leftView = leftView
    }

    public var body: some View {
        VStack {
            Spacer()

            HStack(spacing: 8) {
                leftView()
                
                Text(message)
                    .typographyStyle(.label1Medium, with: .neutral50)

                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .background(Color.neutral900.opacity(0.8))
            .clipShape(.rect(cornerRadius: 16))
        }
    }
}

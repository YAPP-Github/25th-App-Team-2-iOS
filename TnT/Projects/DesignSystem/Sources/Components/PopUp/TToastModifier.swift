//
//  TToastModifier.swift
//  DesignSystem
//
//  Created by 박민서 on 2/3/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// 토스트 메시지를 화면에 표시하는 ViewModifier
/// - `isPresented` 바인딩을 통해 토스트 메시지의 표시 여부를 제어
/// - 애니메이션을 적용하여 자연스럽게 나타났다가 사라지는 효과
public struct TToastViewModifier<InnerContent: View>: ViewModifier {
    /// 토스트에 표시될 내부 콘텐츠 클로저
    private let innerContent: () -> InnerContent
    /// 토스트 표시 여부
    @Binding private var isPresented: Bool
    /// 토스트가 화면에 보이는 상태인지 여부 (애니메이션용)
    @State private var isVisible: Bool = false
    
    /// TToastViewModifier 초기화 메서드
    /// - Parameters:
    ///   - isPresented: 토스트 표시 여부를 제어하는 Binding
    ///   - newContent: 토스트에 표시될 내부 콘텐츠 클로저
    public init(
        isPresented: Binding<Bool>,
        newContent: @escaping () -> InnerContent
    ) {
        self._isPresented = isPresented
        self.innerContent = newContent
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            // 기존 뷰
            content
                .onTapGesture {
                    isPresented = false
                }
            
            if isPresented {
                // 토스트 뷰
                self.innerContent()
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                    .opacity(isVisible ? 1 : 0)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onAppear {
                        showToast()
                    }
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
    
    /// 토스트 메시지를 표시하고 자동으로 사라지도록 처리하는 함수
    private func showToast() {
        // 페이드인
        withAnimation(.easeInOut(duration: 0.3)) {
            isVisible = true
        }
        // 2초간 유지 - 자동으로 사라짐
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // 페이드 아웃
            withAnimation(.easeInOut(duration: 0.3)) {
                isVisible = false
            }
            // present 해제
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isPresented = false
            }
        }
    }
}

public extension View {
    /// 토스트 메시지를 화면에 표시하는 ViewModifier
    ///
    /// - `isPresented`: 토스트의 표시 여부를 제어하는 Binding.
    /// - `message`: 토스트에 표시할 메시지.
    /// - `leftView`: 토스트 좌측에 추가할 아이콘이나 뷰.
    func tToast(
        isPresented: Binding<Bool>,
        message: String,
        leftViewType: TToastView.LeftViewType
    ) -> some View {
        self.modifier(
            TToastViewModifier(
                isPresented: isPresented,
                newContent: {
                    TToastView(message: message, leftViewType: leftViewType)
                }
            )
        )
    }
}

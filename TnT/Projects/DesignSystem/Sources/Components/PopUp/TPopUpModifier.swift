//
//  TPopUpModifier.swift
//  DesignSystem
//
//  Created by 박민서 on 1/16/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// 팝업 컨테이너 (공통 레이아웃)
public struct TPopUpModifier<InnerContent: View>: ViewModifier {
    
    /// 팝업 내부 콘텐츠의 기본 패딩
    private let defaultInnerPadding: CGFloat = 20
    /// 팝업 배경의 기본 불투명도
    /// 0.0 = 완전 투명, 1.0 = 완전 불투명
    private let defaultBackgroundOpacity: Double = 0.8
    /// 팝업의 기본 배경 색상
    private let defaultPopUpBackgroundColor: Color = .white
    /// 팝업 모서리의 기본 곡률 (Corner Radius)
    private let defaultCornerRadius: CGFloat = 16
    /// 팝업 그림자의 기본 반경
    private let defaultShadowRadius: CGFloat = 10
    /// 팝업 콘텐츠의 기본 크기
    private let defaultContentSize: CGSize = .init(width: 297, height: 175)
    
    /// 팝업에 표시될 내부 콘텐츠 클로저
    private let innerContent: () -> InnerContent
    /// 팝업 표시 여부
    @Binding private var isPresented: Bool
    
    /// TPopupModifier 초기화 메서드
    /// - Parameters:
    ///   - isPresented: 팝업 표시 여부를 제어하는 Binding
    ///   - newContent: 팝업에 표시될 내부 콘텐츠 클로저
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
                .zIndex(0)
            
            if isPresented {
                // 반투명 배경
                Color.black.opacity(defaultBackgroundOpacity)
                    .ignoresSafeArea()
                    .zIndex(1)
                    .onTapGesture {
                        isPresented = false
                    }
                
                // 팝업 뷰
                self.innerContent()
                    .frame(minWidth: defaultContentSize.width, minHeight: defaultContentSize.height)
                    .padding(defaultInnerPadding)
                    .background(defaultPopUpBackgroundColor)
                    .cornerRadius(defaultCornerRadius)
                    .shadow(radius: defaultShadowRadius)
                    .padding()
                    .zIndex(2)
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
}

public extension View {
    /// 팝업 표시를 위한 View Modifier
    /// - Parameters:
    ///   - isPresented: 팝업 표시 여부를 제어하는 Binding
    ///   - content: 팝업 내부에 표시할 콘텐츠 클로저
    /// - Returns: 팝업이 추가된 View
    func tPopUp<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(TPopUpModifier<Content>(isPresented: isPresented, newContent: content))
    }
    
    /// `TPopUp.Alert` 팝업 전용 View Modifier
    /// - Parameters:
    ///   - isPresented: 팝업 표시 여부를 제어하는 Binding
    ///   - content: 팝업 알림 내용을 구성하는 클로저
    /// - Returns: 팝업이 추가된 View
    func tPopUp(isPresented: Binding<Bool>, content: @escaping () -> TPopUpAlertView) -> some View {
        self.modifier(TPopUpModifier(isPresented: isPresented, newContent: content))
    }
}

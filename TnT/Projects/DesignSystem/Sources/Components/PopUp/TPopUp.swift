//
//  TPopUp.swift
//  DesignSystem
//
//  Created by 박민서 on 1/15/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// 팝업 관련 네임스페이스
public struct TPopUp {
    /// 팝업 내부 콘텐츠의 기본 패딩
    public static let defaultInnerPadding: CGFloat = 20
    /// 팝업 배경의 기본 불투명도
    /// 0.0 = 완전 투명, 1.0 = 완전 불투명
    public static let defaultBackgroundOpacity: Double = 0.8
    /// 팝업의 기본 배경 색상
    public static let defaultPopUpBackgroundColor: Color = .white
    /// 팝업 모서리의 기본 곡률 (Corner Radius)
    public static let defaultCornerRadius: CGFloat = 16
    /// 팝업 그림자의 기본 반경
    public static let defaultShadowRadius: CGFloat = 10
    /// 팝업 콘텐츠의 기본 크기
    public static let defaultContentSize: CGSize = .init(width: 297, height: 175)
}

extension TPopUp {
    /// 팝업 컨테이너 (공통 레이아웃)
    public struct Modifier<InnerContent: View>: ViewModifier {
        
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
                        .frame(minWidth: TPopUp.defaultContentSize.width, minHeight: TPopUp.defaultContentSize.height)
                        .padding(defaultInnerPadding)
                        .background(defaultPopUpBackgroundColor)
                        .cornerRadius(defaultCornerRadius)
                        .shadow(radius: 10)
                        .padding()
                        .zIndex(2)
                }
            }
            .animation(.bouncy, value: isPresented)
        }
    }
}

extension TPopUp {
    /// 팝업 Alert컨텐츠
    public struct Alert: View {
        /// 팝업 제목
        private let title: String
        /// 팝업 메시지
        private let message: String
        /// 팝업 버튼 배열
        private let buttons: [TPopUp.ButtonContent]

        /// TPopUpAlert 초기화 메서드
        /// - Parameters:
        ///   - title: 팝업 제목
        ///   - message: 팝업 메시지
        ///   - buttons: 팝업 버튼 배열
        public init(title: String, message: String, buttons: [TPopUp.ButtonContent]) {
            self.title = title
            self.message = message
            self.buttons = buttons
        }

        public var body: some View {
            VStack(spacing: 20) {
                // 텍스트 Section
                VStack(spacing: 8) {
                    Text(title)
                        .typographyStyle(.heading4, with: .neutral900)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)

                    Text(message)
                        .typographyStyle(.body2Medium, with: .neutral500)
                        .multilineTextAlignment(.center)
                }
                
                // 버튼 Section
                HStack {
                    // TODO: 버튼 컴포넌트 완성시 대체
                    ForEach(buttons, id: \.title) { button in
                        Button(action: button.action) {
                            Text(button.title)
                                .typographyStyle(.body1Medium, with: button.style == .primary ? Color.neutral50 : Color.neutral500)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(button.style == .primary ? Color.neutral900 : Color.neutral100)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
    }
}

// TODO: 버튼 컴포넌트 완성시 대체
extension TPopUp {
    /// 팝업 버튼 스타일
    public struct ButtonContent {
        /// 버튼 제목
        let title: String
        /// 버튼 스타일
        let style: Style
        /// 버튼 클릭 시 동작
        let action: () -> Void

        public enum Style {
            case primary
            case secondary
        }
        
        /// TPopUpButtonContent 초기화 메서드
        /// - Parameters:
        ///   - title: 버튼 제목
        ///   - style: 버튼 스타일 (기본값: `.primary`)
        ///   - action: 버튼 클릭 시 동작
        public init(
            title: String,
            style: Style = .primary,
            action: @escaping () -> Void = {}
        ) {
            self.title = title
            self.action = action
            self.style = style
        }
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
        self.modifier(TPopUp.Modifier<Content>(isPresented: isPresented, newContent: content))
    }
    
    /// `TPopUp.Alert` 팝업 전용 View Modifier
    /// - Parameters:
    ///   - isPresented: 팝업 표시 여부를 제어하는 Binding
    ///   - content: 팝업 알림 내용을 구성하는 클로저
    /// - Returns: 팝업이 추가된 View
    func tPopUp(isPresented: Binding<Bool>, content: @escaping () -> TPopUp.Alert) -> some View {
        self.modifier(TPopUp.Modifier(isPresented: isPresented, newContent: content))
    }
}

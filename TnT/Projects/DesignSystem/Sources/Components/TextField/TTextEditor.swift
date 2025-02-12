//
//  TTextEditor.swift
//  DesignSystem
//
//  Created by 박민서 on 1/14/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// TnT 앱 내에서 전반적으로 사용되는 커스텀 텍스트 에디터 컴포넌트입니다.
public struct TTextEditor: View {
    
    /// TextEditor 수평 패딩 값
    private static let horizontalPadding: CGFloat = 16
    /// TextEditor 수직 패딩 값
    private static let verticalPadding: CGFloat = 12
    /// TextEditor 기본 높이값
    public static let defaultHeight: CGFloat = 40
    
    /// 하단에 표시되는 푸터 뷰
    private let footer: Footer?
    /// Placeholder 텍스트
    private let placeholder: String
    /// 텍스트 에디터 사이즈
    private let size: Size
    /// 텍스트 필드 상태
    @Binding private var status: Status
    /// 입력된 텍스트
    @Binding private var text: String
    
    /// 내부에서 동적으로 관리되는 텍스트 에디터 높이
    @State private var textHeight: CGFloat = defaultHeight
    /// 텍스트 에디터 포커스 상태
    @FocusState var isFocused: Bool
    
    /// TTextEditor 생성자
    /// - Parameters:
    ///   - placeholder: Placeholder 텍스트 (기본값: "내용을 입력해주세요").
    ///   - size: 텍스트 에디터 사이즈.
    ///   - text: 입력된 텍스트를 관리하는 바인딩.
    ///   - textEditorStatus: 텍스트 에디터 상태를 관리하는 바인딩.
    ///   - footer: Textfield 하단에 표시될 `TTextEditor.FooterView`를 정의하는 클로저.
    public init(
        placeholder: String = "내용을 입력해주세요",
        size: Size = .large,
        text: Binding<String>,
        textEditorStatus: Binding<Status>,
        footer: () -> Footer? = { nil }
    ) {
        self.placeholder = placeholder
        self.size = size
        self._text = text
        self._status = textEditorStatus
        self.footer = footer()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .autocorrectionDisabled()
                    .scrollDisabled(true)
                    .focused($isFocused)
                    .font(Typography.FontStyle.body1Medium.font)
                    .lineSpacing(Typography.FontStyle.body1Medium.lineSpacing)
                    .kerning(Typography.FontStyle.body1Medium.letterSpacing)
                    .tint(Color.neutral800)
                    .frame(minHeight: textHeight, maxHeight: .infinity)
                    .padding(.vertical, TTextEditor.verticalPadding)
                    .padding(.horizontal, TTextEditor.horizontalPadding)
                    .background(Color.common0)
                    .scrollContentBackground(.hidden)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(status.borderColor(isFocused: isFocused), lineWidth: status.borderWidth(isFocused: isFocused))
                    )
                    .frame(height: size.height)
                
                if text.isEmpty {
                    Text(placeholder)
                        .typographyStyle(.body1Medium, with: .neutral400)
                        .padding(.vertical, TTextEditor.verticalPadding + 8)
                        .padding(.horizontal, TTextEditor.horizontalPadding + 4)
                }
            }
            if let footer {
                footer
            }
        }
    }
}

public extension TTextEditor {
    /// TTextEditor의 Footer입니다
    struct Footer: View {
        /// 최대 입력 가능 글자 수
        private let textLimit: Int
        /// 입력된 텍스트 카운트
        private var textCount: Int
        /// 경고 텍스트
        private var warningText: String
        /// 텍스트 필드 상태
        @Binding private var status: Status
        
        /// Footer 생성자
        /// - Parameters:
        ///   - textLimit: 최대 입력 가능 글자 수.
        ///   - status: 텍스트 에디터의 상태를 관리하는 바인딩.
        ///   - textLimit: 입력된 텍스트 글자 수.
        public init(
            textLimit: Int,
            status: Binding<Status>,
            textCount: Int,
            warningText: String = "글자 수를 초과했어요"
        ) {
            self.textLimit = textLimit
            self.textCount = textCount
            self._status = status
            self.warningText = warningText
        }
        
        public var body: some View {
            HStack {
                if status == .invalid {
                    Text(warningText)
                        .typographyStyle(.label2Medium, with: status.footerColor)
                }
                Spacer()
                Text("\(textCount)/\(textLimit)")
                    .typographyStyle(.label2Medium, with: status.footerColor)
            }
        }
    }
}

public extension TTextEditor {
    /// TextEditor에 표시되는 상태입니다
    enum Status {
        case empty
        case filled
        case invalid
        
        /// 테두리 두께 설정
        func borderWidth(isFocused: Bool) -> CGFloat {
            switch self {
            case .invalid:
                return 2 // Focus와 상관없이 2
            default:
                return isFocused ? 2 : 1
            }
        }
        
        /// 테두리 색상 설정
        func borderColor(isFocused: Bool) -> Color {
            switch self {
            case .invalid:
                return .red500 // Focus와 상관없이 .red500
            case .empty:
                return isFocused ? .neutral900 : .neutral200
            case .filled:
                return isFocused ? .neutral900 : .neutral600
            }
        }
        
        /// 텍스트 색상 설정
        var textColor: Color {
            switch self {
            case .empty:
                return .neutral400
            case .filled, .invalid:
                return .neutral600
            }
        }
        
        /// 푸터 색상 설정
        var footerColor: Color {
            switch self {
            case .empty, .filled:
                return .neutral300
            case .invalid:
                return .red500
            }
        }
    }
    
    /// TextEditor의 크기
    enum Size {
        case small
        case large
        
        /// 높이
        var height: CGFloat {
            switch self {
            case .small:
                return 52
            case .large:
                return 130
            }
        }
    }
}

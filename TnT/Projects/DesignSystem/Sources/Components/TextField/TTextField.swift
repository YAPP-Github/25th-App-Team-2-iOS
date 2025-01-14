//
//  TTextField.swift
//  DesignSystem
//
//  Created by 박민서 on 1/14/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// TnT 앱 내에서 전반적으로 사용되는 커스텀 텍스트 필드 컴포넌트입니다.
public struct TTextField: View {
    
    /// Placeholder 텍스트
    private let placeholder: String
    /// 상단 헤더 설정
    private let header: HeaderContent?
    /// 하단 푸터 텍스트
    private let footerText: String?
    /// 우측 단위 텍스트
    private let unitText: String?
    /// 우측 버튼 설정
    private let button: ButtonContent?
    /// 키보드 타입
    private let keyboardType: UIKeyboardType
    
    /// 입력 텍스트
    @Binding private var text: String
    /// 텍스트 필드 상태
    @Binding private var status: Status
    
    /// - Parameters:
    ///   - placeholder: Placeholder 텍스트 (기본값: "내용을 입력해주세요")
    ///   - header: 상단 헤더 설정 (옵션)
    ///   - footerText: 하단 푸터 텍스트 (옵션)
    ///   - unitText: 우측 단위 텍스트 (옵션)
    ///   - button: 우측 버튼 설정 (옵션)
    ///   - keyboardType: 텍스트 필드 키보드 타입 (기본값: .default)
    ///   - text: 입력 텍스트 (Binding)
    ///   - textFieldStatus: 텍스트 필드 상태 (Binding)
    public init(
        placeholder: String = "내용을 입력해주세요",
        header: HeaderContent? = nil,
        footerText: String? = nil,
        unitText: String? = nil,
        button: ButtonContent? = nil,
        keyboardType: UIKeyboardType = .default,
        text: Binding<String>,
        textFieldStatus: Binding<Status>
    ) {
        self.placeholder = placeholder
        self.header = header
        self.footerText = footerText
        self.unitText = unitText
        self.button = button
        self.keyboardType = keyboardType
        self._text = text
        self._status = textFieldStatus
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            if let header {
                HStack(spacing: 0) {
                    Text(header.title)
                        .typographyStyle(.body1Bold, with: .neutral900)
                    if header.isRequired {
                        Text("*")
                            .typographyStyle(.body1Bold, with: .red500)
                    }
                    
                    Spacer()
                    
                    if let limitCount = header.limitCount {
                        Text("\(text.count)/\(limitCount)자")
                            .typographyStyle(.label1Medium, with: .neutral400)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                    }
                }
            }
            
            // Text Field
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .multilineTextAlignment(unitText != nil ? .trailing : .leading)
                        .padding(8)

                    if let unitText {
                        Text(unitText)
                            .typographyStyle(.body1Medium, with: status.style.textColor)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 3)
                    }
                    
                    if let button {
                        // TODO: 추후 버튼 컴포넌트 나오면 대체
                        Button(action: button.tapAction ?? { print("Button tapped") }) {
                            Text(button.title)
                                .typographyStyle(.label2Medium, with: .neutral50)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .background(Color.neutral900)
                                .clipShape(.rect(cornerRadius: 8))
                        }
                        .padding(.vertical, 5)
                    }
                }
                
                TDivider(color: status.style.statusColor)
            }
            
            // Footer
            if let footer = footerText {
                Text(footer)
                    .typographyStyle(.body2Medium, with: status.style.statusColor)
            }
        }
    }
}

public extension TTextField {
    /// TextField에 표시되는 상태입니다
    enum Status {
        case empty
        case focused
        case invalid
        case valid
        case filled
        
        /// Status에 따른 컬러웨이입니다
        var style: (statusColor: Color, textColor: Color) {
            switch self {
            case .empty, .filled:
                return (.neutral200, .neutral400)
            case .focused:
                return (.neutral600, .neutral600)
            case .invalid:
                return (.red500, .neutral600)
            case .valid:
                return (.blue500, .neutral600)
            }
        }
    }
}

public extension TTextField {
    /// TextField 상단 헤더 설정입니다
    struct HeaderContent {
        /// 필수 여부를 표시
        let isRequired: Bool
        /// 헤더의 제목
        let title: String
        /// 입력 가능한 글자 수 제한
        let limitCount: Int?
        
        public init(isRequired: Bool, title: String, limitCount: Int?) {
            self.isRequired = isRequired
            self.title = title
            self.limitCount = limitCount
        }
    }
    
    /// TextField 우측 버튼 설정입니다
    struct ButtonContent {
        /// 버튼에 표시될 텍스트
        let title: String
        /// 버튼 클릭 시 실행되는 동작
        let tapAction: (() -> Void)?
        
        public init(title: String, tapAction: (() -> Void)?) {
            self.title = title
            self.tapAction = tapAction
        }
    }
}

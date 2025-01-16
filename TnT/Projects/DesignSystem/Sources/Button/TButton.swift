//
//  TButton.swift
//  DesignSystem
//
//  Created by 박서연 on 1/15/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

public enum ButtonPostiton {
    case right
    case left
    case both
}

/// TnT 앱 내에서 전반적으로 사용되는 커스텀 버튼(텍스트+옵셔널 이미지) 컴포넌트입니다
public struct TButton: View {
    /// 버튼의 상태 (default 또는 disable 상태)
    public let state: ButtonState
    
    /// 버튼의 크기 및 스타일 구성
    public let config: ButtonConfiguration
    
    /// 버튼의 제목
    public let title: String
    
    /// 버튼에 표시될 이미지 속성
    public let image: ButtonImage?
    
    /// 버튼 탭 시 수행할 동작 (옵셔널)
    public var action: (() -> Void)
    
    /// TButton의 초기화 메서드
    /// - Parameters:
    ///   - state: 버튼의 상태
    ///   - config: 버튼 구성 (크기, 글꼴 등)
    ///   - title: 버튼 제목
    ///   - image: 버튼 이미지 (옵셔널)
    ///   - imageSize: 이미지 크기 (옵셔널)
    ///   - action: 버튼 탭 시 동작 (옵셔널)
    public init(
        title: String,
        config: ButtonConfiguration,
        state: ButtonState,
        image: ButtonImage? = nil,
        action: (@escaping () -> Void)
    ) {
        self.title = title
        self.config = config
        self.state = state
        self.image = image
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 4) {
                // 왼쪽 이미지 추가
                if let leftImage = image, leftImage.type == .left || leftImage.type == .both {
                    Image(leftImage.resource)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: leftImage.size, height: leftImage.size)
                }
                
                // 제목 추가
                Text(title)
                .typographyStyle(config.font, with: textColor)
                .frame(maxWidth: .infinity, alignment: .center)
                
                // 오른쪽 이미지 추가
                if let rightImage = image, rightImage.type == .right || rightImage.type == .both {
                    Image(rightImage.resource)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: rightImage.size, height: rightImage.size)
                }
            }
            .padding(.vertical, config.verticalSize)
            .padding(.horizontal, config.horizontalSize)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: config.radius))
            .overlay {
                RoundedRectangle(cornerRadius: config.radius)
                    .stroke(borderColor, lineWidth: 1.5)
            }
            .contentShape(Rectangle())
        }
    }
    
    /// 버튼의 배경색
    private var backgroundColor: Color {
        switch state {
        case .default(let style):
            return style.backgound
        case .disable(let style):
            return style.backgound
        }
    }
    
    /// 버튼의 텍스트 색상
    private var textColor: Color {
        switch state {
        case .default(let style):
            return style.textColor
        case .disable(let style):
            return style.textColor
        }
    }
    
    /// 버튼의 외곽선 색상
    private var borderColor: Color {
        switch state {
        case .default(let style):
            return style.borderColor
        case .disable(let style):
            return style.borderColor
        }
    }
}

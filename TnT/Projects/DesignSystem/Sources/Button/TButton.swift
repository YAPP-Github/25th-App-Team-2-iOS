//
//  TButton.swift
//  DesignSystem
//
//  Created by 박서연 on 1/15/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// TnT 앱 내에서 전반적으로 사용되는 커스텀 버튼(텍스트+옵셔널 이미지) 컴포넌트입니다
public struct TButton: View {
    /// 버튼의 상태 (default 또는 disable 상태)
    public let state: ButtonState
    
    /// 버튼의 크기 및 스타일 구성
    public let config: ButtonConfiguration
    
    /// 버튼의 제목
    public let title: String
    
    /// 버튼에 표시될 이미지 (옵셔널)
    public let image: ImageResource?
    
    /// 이미지의 크기 (옵셔널)
    public let imageSize: CGFloat?
    
    /// 버튼의 활성화 여부 (기본값: `false`)
    public var isEnable: Bool = false
    
    /// 버튼 탭 시 수행할 동작 (옵셔널)
    public var action: (() -> Void)?
    
    /// TButton의 초기화 메서드
    /// - Parameters:
    ///   - state: 버튼의 상태
    ///   - config: 버튼 구성 (크기, 글꼴 등)
    ///   - title: 버튼 제목
    ///   - image: 버튼 이미지 (옵셔널)
    ///   - imageSize: 이미지 크기 (옵셔널)
    ///   - isEnable: 활성화 여부 (기본값: `false`)
    ///   - action: 버튼 탭 시 동작 (옵셔널)
    public init(
        state: ButtonState,
        config: ButtonConfiguration,
        title: String,
        image: ImageResource? = nil,
        imageSize: CGFloat? = nil,
        isEnable: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.state = state
        self.config = config
        self.title = title
        self.image = image
        self.imageSize = imageSize
        self.isEnable = isEnable
        self.action = action
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            if let image = image, let imageSize = imageSize {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageSize, height: imageSize)
            }
            
            Text(title)
                .typographyStyle(config.font, with: textColor)
        }
        .padding(.vertical, config.verticalSize)
        .padding(.horizontal, 20)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: config.radius))
        .overlay {
            RoundedRectangle(cornerRadius: config.radius)
                .stroke(borderColor, lineWidth: 1.5)
        }
        .onTapGesture {
            if isEnable {
                action?()
            }
        }
    }
    
    /// 버튼의 배경색
    private var backgroundColor: Color {
        switch state {
        case .default(let style):
            return style.backgound
        case .disable(let style):
            return style.background
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

public extension TButton {
    /// 버튼의 활성화 상태를 설정하는 메서드
    /// - Parameter isEnable: 활성화 여부
    /// - Returns: 업데이트된 TButton
    func isEnable(_ isEnable: Bool) -> Self {
        var copy: Self = self
        copy.isEnable = isEnable
        return copy
    }
    
    /// 버튼의 탭 동작을 설정하는 메서드
    /// - Parameter action: 수행할 동작
    /// - Returns: 업데이트된 TButton
    func tap(action: @escaping (() -> Void)) -> Self {
        var copy: Self = self
        copy.action = action
        return copy
    }
}

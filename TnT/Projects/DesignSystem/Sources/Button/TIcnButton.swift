//
//  TIcnButton.swift
//  DesignSystem
//
//  Created by 박서연 on 1/15/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// TnT 앱 내에서 전반적으로 사용되는 커스텀 아이콘 전용 버튼 컴포넌트입니다
public struct TIcnButton: View {
    /// 버튼의 아이콘 이미지 리소스
    public let image: ButtonImage
    /// 버튼의 크기별 속성(패딩 및 코너 반경 등)을 정의한 설정값
    public var config: IcnButtonConfiguration
    /// 버튼이 탭되었을 때 실행할 액션 (Optional)
    public var action: (() -> Void)
    
    /// TIcnButton 초기화 메서드
    /// - Parameters:
    ///   - image: 버튼에 표시할 아이콘 이미지
    ///   - config: 버튼 크기 설정값
    ///   - action: 버튼 클릭 시 실행될 액션 (Optional)
    public init(
        image: ButtonImage,
        config: IcnButtonConfiguration,
        action: (@escaping () -> Void)
    ) {
        self.image = image
        self.config = config
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Image(image.resource)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: image.size, height: image.size)
                .padding(.all, config.padding)
                .background(Color.neutral900)
                .clipShape(RoundedRectangle(cornerRadius: config.radius))
        }
    }
}

public extension TIcnButton {
    /// 아이콘 버튼의 크기별 설정값을 정의하는 열거형
    enum IcnButtonConfiguration {
        case large
        case medium
        
        /// 버튼 크기별 패딩 값
        public var padding: CGFloat {
            switch self {
            case .large:
                return 16
            case .medium:
                return 12
            }
        }
        
        /// 버튼 크기별 코너 반경 값
        public var radius: CGFloat {
            switch self {
            case .large:
                return 16
            case .medium:
                return 12
            }
        }
    }

}

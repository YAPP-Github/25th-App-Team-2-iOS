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
    public let image: ImageResource
    /// 버튼 아이콘 이미지의 크기
    public let imageSize: CGFloat
    /// 버튼의 크기별 속성(패딩 및 코너 반경 등)을 정의한 설정값
    public let config: IcnButtonConfiguration
    /// 버튼이 탭되었을 때 실행할 액션 (Optional)
    public var action: (() -> Void)?
    /// 버튼 활성화 여부를 나타내는 플래그 (기본값: 비활성화)
    public var isEnable: Bool = false
    
    /// TIcnButton 초기화 메서드
    /// - Parameters:
    ///   - image: 버튼에 표시할 아이콘 이미지
    ///   - imageSize: 아이콘 이미지의 크기
    ///   - config: 버튼 크기 설정값
    ///   - action: 버튼 클릭 시 실행될 액션 (Optional)
    public init(
        image: ImageResource,
        imageSize: CGFloat,
        config: IcnButtonConfiguration,
        action: (() -> Void)? = nil
    ) {
        self.image = image
        self.imageSize = imageSize
        self.config = config
        self.action = action
    }
    
    public var body: some View {
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: imageSize, height: imageSize)
            .padding(.all, config.padding)
            .background(Color.neutral900)
            .clipShape(RoundedRectangle(cornerRadius: config.radius))
            .onTapGesture {
                if isEnable {
                    action?()
                }
            }
    }
}

/// 아이콘 버튼의 크기별 설정값을 정의하는 열거형
public enum IcnButtonConfiguration {
    case large
    case medium
    
    /// 버튼 크기별 패딩 값
    var padding: CGFloat {
        switch self {
        case .large:
            return 16
        case .medium:
            return 12
        }
    }
    
    /// 버튼 크기별 코너 반경 값
    var radius: CGFloat {
        switch self {
        case .large:
            return 16
        case .medium:
            return 12
        }
    }
}

public extension TIcnButton {
    /// 버튼의 액션을 설정하는 메서드
    /// - Parameter action: 버튼 탭 시 실행될 클로저
    /// - Returns: 설정이 적용된 새로운 버튼 인스턴스
    func tap(action: @escaping (() -> Void)) -> Self {
        var copy: Self = self
        copy.action = action
        return copy
    }
    
    /// 버튼 활성화 여부를 설정하는 메서드
    /// - Parameter isEnable: 버튼 활성화 여부 (true: 활성화, false: 비활성화)
    /// - Returns: 설정이 적용된 새로운 버튼 인스턴스
    func isEnable(_ isEnable: Bool) -> Self {
        var copy: Self = self
        copy.isEnable = isEnable
        return copy
    }
}

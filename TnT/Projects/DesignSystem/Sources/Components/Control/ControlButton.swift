//
//  TControlButton.swift
//  DesignSystem
//
//  Created by 박민서 on 1/15/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// TnT 앱 내에서 전반적으로 사용되는 커스텀 컨트롤 버튼 컴포넌트입니다.
public struct TControlButton: View {
    /// 버틉 탭 액션
    private let tapAction: () -> Void
    /// 버튼 스타일
    private let type: Style
    /// 버튼 선택 상태
    @Binding private var isSelected: Bool
    
    /// TControlButton 생성자
    /// - Parameters:
    ///   - type: 버튼의 스타일. `TControlButton.Style` 사용.
    ///   - isSelected: 버튼의 선택 상태를 관리하는 바인딩.
    ///   - action: 버튼이 탭되었을 때 실행할 액션. (기본값: 빈 클로저)
    public init(
        type: Style,
        isSelected: Binding<Bool>,
        action: @escaping () -> Void = {}
    ) {
        self.type = type
        self._isSelected = isSelected
        self.tapAction = action
    }
    
    public var body: some View {
        Button(action: {
            isSelected.toggle()
            tapAction()
        }, label: {
            type.image(isSelected: isSelected)
                .resizable()
                .scaledToFit()
                .frame(width: type.defaultSize.width, height: type.defaultSize.height)
        })
    }
}

public extension TControlButton {
    /// TControlButton의 스타일입니다.
    enum Style {
        case radio
        case checkMark
        case checkbox
        case toggle
        case star
        case heart
        
        /// 선택 상태에 따른 이미지 반환
        func image(isSelected: Bool) -> Image {
            switch self {
                
            case .radio:
                return Image(isSelected ? .icnRadioButtonSelected : .icnRadioButtonUnselected)
            case .checkMark:
                return Image(isSelected ? .icnCheckMarkFilled : .icnCheckMarkEmpty)
            case .checkbox:
                return Image(isSelected ? .icnCheckButtonSelected : .icnCheckButtonUnselected)
            case .toggle:
                return Image(isSelected ? .icnToggleSelected : .icnToggleUnselected)
            case .star:
                return Image(isSelected ? .icnStarFilled : .icnStarEmpty)
            case .heart:
                return Image(isSelected ? .icnHeartFilled : .icnHeartEmpty)
            }
        }
        
        /// 스타일에 따른 기본 크기
        var defaultSize: CGSize {
            switch self {
            case .toggle:
                return .init(width: 44, height: 24)
            default:
                return .init(width: 24, height: 24)
            }
        }
    }
}

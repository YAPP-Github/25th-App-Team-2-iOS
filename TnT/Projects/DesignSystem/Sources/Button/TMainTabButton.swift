//
//  TMainTabButton.swift
//  DesignSystem
//
//  Created by 박민서 on 2/5/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// TnT 앱 내에서 바텀 탭에 사용되는 버튼 컴포넌트 입니다
public struct TMainTabButton: View {
    let unselectedIcon: ImageResource
    let selectedIcon: ImageResource
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    public init(
        unselectedIcon: ImageResource,
        selectedIcon: ImageResource,
        text: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.unselectedIcon = unselectedIcon
        self.selectedIcon = selectedIcon
        self.text = text
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(isSelected ? selectedIcon : unselectedIcon)
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(text)
                    .typographyStyle(
                        isSelected ? .label2Bold : .label1Medium,
                        with: isSelected ? .neutral900 : .neutral400
                    )
            }
        }
        .padding(.vertical, 8)
    }
}

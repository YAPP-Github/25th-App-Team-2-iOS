//
//  Toast.swift
//  Presentation
//
//  Created by 박민서 on 2/9/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

import DesignSystem

/// 개별 토스트 데이터 (좌측 뷰 타입, 메시지, 지속시간, 탭 시 해제 가능 여부)
public struct Toast: Identifiable, Equatable {
    public let id = UUID()
    public let leftViewType: TToastView.LeftViewType
    public let message: String
    public let duration: TimeInterval
    public let dismissibleOnTap: Bool
    
    public init(
        leftViewType: TToastView.LeftViewType,
        message: String,
        duration: TimeInterval = 2.0,
        dismissibleOnTap: Bool = true
    ) {
        self.leftViewType = leftViewType
        self.message = message
        self.duration = duration
        self.dismissibleOnTap = dismissibleOnTap
    }
}

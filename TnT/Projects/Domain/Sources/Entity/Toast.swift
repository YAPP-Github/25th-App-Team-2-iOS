//
//  Toast.swift
//  Domain
//
//  Created by 박민서 on 2/9/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// 개별 토스트 데이터 (좌측 뷰 타입, 메시지, 지속시간, 탭 시 해제 가능 여부)
public struct Toast: Identifiable, Equatable {
    public let id = UUID()
    public let presentType: PresentType
    public let message: String
    public let duration: TimeInterval
    public let dismissibleOnTap: Bool
    
    public init(
        presentType: PresentType,
        message: String,
        duration: TimeInterval = 2.0,
        dismissibleOnTap: Bool = true
    ) {
        self.presentType = presentType
        self.message = message
        self.duration = duration
        self.dismissibleOnTap = dismissibleOnTap
    }
}

public extension Toast {
    enum PresentType: Equatable {
        case text(String)
        case image(ImageResource)
        case processing
        case none
    }
}

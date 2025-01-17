//
//  TButtonInfo.swift
//  DesignSystem
//
//  Created by 박서연 on 1/15/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// 버튼의 이미지를 위한 구조체
public struct ButtonImage {
    public let resource: ImageResource
    public let size: CGFloat
    public let type: ButtonPostiton?
    
    public init(
        resource: ImageResource,
        size: CGFloat,
        type: ButtonPostiton? = nil
    ) {
        self.resource = resource
        self.size = size
        self.type = type
    }
}


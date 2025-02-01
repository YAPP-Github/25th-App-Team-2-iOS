//
//  RecordListItemEntity.swift
//  Domain
//
//  Created by 박민서 on 2/2/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 트레이니 기록 목록 아이템 모델
public struct RecordListItemEntity {
    /// 기록 타입
    public let type: RecordType
    /// 기록 시간
    public let date: Date
    /// 기록 제목
    public let title: String
    /// 피드백 여부
    public let hasFeedBack: Bool
    /// 기록 이미지 URL
    public let imageUrl: String?
    
    public init(
        type: RecordType,
        date: Date,
        title: String,
        hasFeedBack: Bool,
        imageUrl: String?
    ) {
        self.type = type
        self.date = date
        self.title = title
        self.hasFeedBack = hasFeedBack
        self.imageUrl = imageUrl
    }
}

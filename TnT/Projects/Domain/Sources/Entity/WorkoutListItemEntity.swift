//
//  WorkoutListItemEntity.swift
//  Domain
//
//  Created by 박민서 on 2/2/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 트레이니 PT 운동 목록 아이템 모델
public struct WorkoutListItemEntity: Equatable, Sendable {
    /// 수업 Id
    public let id: Int
    /// 현재 수업 차수
    public let currentCount: Int
    /// 수업 시작 시간
    public let startDate: Date?
    /// 수업 종료 시간
    public let endDate: Date?
    /// 트레이너 프로필 사진 URL
    public let trainerProfileImageUrl: String?
    /// 트레이너 이름
    public let trainerName: String
    /// 기록 여부
    public let hasRecord: Bool
    
    public init(
        id: Int,
        currentCount: Int,
        startDate: Date?,
        endDate: Date?,
        trainerProfileImageUrl: String?,
        trainerName: String,
        hasRecord: Bool
    ) {
        self.id = id
        self.currentCount = currentCount
        self.startDate = startDate
        self.endDate = endDate
        self.trainerProfileImageUrl = trainerProfileImageUrl
        self.trainerName = trainerName
        self.hasRecord = hasRecord
    }
}

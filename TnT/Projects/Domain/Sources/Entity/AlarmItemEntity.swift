//
//  AlarmItemEntity.swift
//  Domain
//
//  Created by 박민서 on 2/2/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 알람 확인시 사용되는 알람 정보 구조체
public struct AlarmItemEntity {
    /// 알람 타입
    public let alarmType: AlarmType
    /// 알람 도착 시각
    public let alarmDate: Date
    /// 알람 확인 여부
    public let alarmSeenBefore: Bool
    
    public init(
        alarmType: AlarmType,
        alarmDate: Date,
        alarmSeenBefore: Bool
    ) {
        self.alarmType = alarmType
        self.alarmDate = alarmDate
        self.alarmSeenBefore = alarmSeenBefore
    }
}

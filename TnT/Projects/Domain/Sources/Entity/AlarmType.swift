//
//  AlarmType.swift
//  Domain
//
//  Created by 박민서 on 2/2/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 앱에서 존재하는 알람 유형을 정의한 열거형
public enum AlarmType {
    /// 트레이니 연결 완료
    case traineeConnected(name: String)
    /// 트레이니 연결 해제
    case traineeDisconnected(name: String)
    /// 트레이너 연결 해제
    case trainerDisconnected(name: String)
}

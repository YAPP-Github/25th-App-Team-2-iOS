//
//  TraineeConnectInfo.swift
//  Domain
//
//  Created by 박민서 on 1/27/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 트레이너 연결을 위한 도메인 모델
public struct TraineeConnectInfo {
    /// 초대 코드
    public let invitationCode: String
    /// 시작 날짜
    public let startDate: String
    /// 총 PT 횟수
    public let totalPtCount: Int
    /// 현재 PT 횟수
    public let finishedPtCount: Int
}

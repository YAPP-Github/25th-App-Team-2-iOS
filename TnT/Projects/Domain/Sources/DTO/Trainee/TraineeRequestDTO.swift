//
//  TraineeRequestDTO.swift
//  Domain
//
//  Created by 박민서 on 1/27/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 트레이너 연결 요청 DTO
public struct PostConnectTrainerReqDTO: Encodable {
    /// 초대 코드
    public let invitationCode: String
    /// 시작 날짜
    public let startDate: String
    /// 총 PT 횟수
    public let totalPtCount: Int
    /// 현재 PT 횟수
    public let finishedPtCount: Int
    
    public init(
        invitationCode: String,
        startDate: String,
        totalPtCount: Int,
        finishedPtCount: Int
    ) {
        self.invitationCode = invitationCode
        self.startDate = startDate
        self.totalPtCount = totalPtCount
        self.finishedPtCount = finishedPtCount
    }
}

/// 트레이니 식단 기록 요청 DTO
public struct PostTraineeDietRecordReqDTO: Encodable {
    /// 식단 dateTime
    public let date: String
    /// 식단 타입
    public let dietType: String
    /// 식단 메모
    public let memo: String
    
    public init(
        date: String,
        dietType: String,
        memo: String
    ) {
        self.date = date
        self.dietType = dietType
        self.memo = memo
    }
}

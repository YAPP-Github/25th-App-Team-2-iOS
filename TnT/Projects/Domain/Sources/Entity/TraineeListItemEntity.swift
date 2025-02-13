//
//  TraineeListItemEntity.swift
//  Domain
//
//  Created by 박민서 on 2/6/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 회원 목록 아이템 모델
public struct TraineeListItemEntity: Equatable, Sendable {
    /// 회원 Id
    public let id: Int
    /// 회원 이름
    public let name: String
    
    public init(
        id: Int,
        name: String
    ) {
        self.id = id
        self.name = name
    }
}

/// 관리 중인 회원 목록 응답 DTO
public struct GetActiveTraineesListResEntity: Equatable {
    public let trainees: [ActiveTraineeInfoResEntity]
}

/// 관리 중인 회원 정보 DTO
public struct ActiveTraineeInfoResEntity: Sendable, Equatable {
    public let id: Int
    public let name: String
    public let profileImageUrl: String
    public let finishedPtCount: Int
    public let totalPtCount: Int
    public let memo: String
    public let ptGoals: [String]
}

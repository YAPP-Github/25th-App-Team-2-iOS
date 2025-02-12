//
//  MyPageEntity.swift
//  Domain
//
//  Created by 박민서 on 2/12/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

public struct TraineeMyPageEntity: Equatable, Sendable {
    /// 트레이니 이름
    public let name: String
    /// 트레이니 프로필 이미지 URL
    public let profileImageUrl: String
    /// 소셜 타입
    public let socialType: String
}

public struct TrainerMyPageEntity: Equatable, Sendable {
    /// 트레이너 이름
    public let name: String
    /// 트레이너 프로필 이미지 URL
    public let profileImageUrl: String
    /// 소셜 타입
    public let socialType: String
    /// 관리 중인 회원 수
    public let activeTraineeCount: Int?
    /// 함께했던 회원 수
    public let totalTraineeCount: Int?
}

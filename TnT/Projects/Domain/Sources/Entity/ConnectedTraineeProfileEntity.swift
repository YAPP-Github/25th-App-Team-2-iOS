//
//  ConnectedTraineeProfileEntity.swift
//  Domain
//
//  Created by 박민서 on 2/11/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 연결 완료된 트레이니의 프로필
public struct ConnectedTraineeProfileEntity: Equatable, Sendable {
    /// 트레이니 이름
    public let traineeName: String
    /// 트레이니 프로필 이미지 url
    public let imageUrl: String
    /// 나이
    public let age: Int?
    /// 키
    public let height: Double
    /// 몸무게
    public let weight: Double
    /// PT 목표
    public let ptGoal: String
    /// 주의 사항
    public let cautionNote: String?
    
    public init(
        traineeName: String,
        imageUrl: String,
        age: Int?,
        height: Double,
        weight: Double,
        ptGoal: String,
        cautionNote: String?
    ) {
        self.traineeName = traineeName
        self.imageUrl = imageUrl
        self.age = age
        self.height = height
        self.weight = weight
        self.ptGoal = ptGoal
        self.cautionNote = cautionNote
    }
}

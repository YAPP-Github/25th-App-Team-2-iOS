//
//  GetMembersListEntity.swift
//  Domain
//
//  Created by 박서연 on 2/8/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 트레이너 회원 조회 DTO
public struct GetMembersListEntity: Encodable, Equatable {
    /// ID 값 활용을 위한 추가
    public let id: String
    /// 이름
    public let name: String
    /// 이메일
    public let email: String
    /// 프로필 사진
    public let profileImageUrl: String
    /// 생년월일
    public let birthday: String?
    /// 유저 타입 (트레이너/트레이니)
    public let memberType: String
    /// 소셜 로그인 타입
    public let socialType: String
    /// 관리중인 회원의 수
    public let managementMember: Int
    /// 함께했던 회원의 수
    public let fellowMember: Int
    /// 트레이너 ID
    public let trainerId: String
    /// 트레이니 키
    public let height: Double?
    /// 트레이니 무게
    public let weight: Double?
    /// 주의사항
    public let cautionNote: String?
    /// PT 목표
    public let goalContents: [String]
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        email: String,
        profileImageUrl: String,
        birthday: String?,
        memberType: String,
        socialType: String,
        managementMember: Int,
        fellowMember: Int,
        trainerId: String,
        height: Double?,
        weight: Double?,
        cautionNote: String?,
        goalContents: [String]
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.birthday = birthday
        self.memberType = memberType
        self.socialType = socialType
        self.managementMember = managementMember
        self.fellowMember = fellowMember
        self.trainerId = trainerId
        self.height = height
        self.weight = weight
        self.cautionNote = cautionNote
        self.goalContents = goalContents
    }
}

extension GetMembersListEntity {
    static func toDTO(entity: GetMembersListEntity) -> GetMembersListDTO {
        return GetMembersListDTO(
            name: entity.name,
            email: entity.email,
            profileImageUrl: entity.profileImageUrl,
            birthday: entity.birthday ?? "",
            memberType: entity.memberType,
            socialType: entity.socialType,
            managementMember: entity.managementMember,
            fellowMember: entity.fellowMember,
            trainerId: entity.trainerId,
            height: entity.height ?? 0.0,
            weight: entity.weight ?? 0.0,
            cautionNote: entity.cautionNote ?? "",
            goalContents: entity.goalContents)
    }
}

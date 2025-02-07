//
//  GetMembersListDTO.swift
//  Domain
//
//  Created by 박서연 on 2/8/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 트레이너 회원 조회 DTO
public struct GetMembersListDTO: Decodable {
    /// 이름
    public let name: String
    /// 이메일
    public let email: String
    /// 프로필 사진
    public let profileImageUrl: String
    /// 생년월일
    public let birthday: String
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
    public let height: Double
    /// 트레이니 무게
    public let weight: Double
    /// 주의사항
    public let cautionNote: String
    /// PT 목표
    public let goalContents: [String]
}

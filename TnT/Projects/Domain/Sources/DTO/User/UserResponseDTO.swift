//
//  UserResponseDTO.swift
//  Domain
//
//  Created by 박민서 on 1/25/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 소셜 로그인 응답 DTO
public struct PostSocialLoginResDTO: Decodable {
    /// 세션 ID
    public let sessionId: String?
    /// 소셜 로그인 ID
    public let socialId: String?
    /// 소셜 이메일
    public let socialEmail: String?
    /// 소셜 로그인 타입 (KAKAO, APPLE)
    public let socialType: String?
    /// 가입 여부 (`true`: 이미 가입됨, `false`: 미가입)
    public let isSignUp: Bool
    /// 회원 타입 (TRAINER, TRAINEE, UNREGISTERED)
    public let memberType: MemberTypeResDTO
}

/// Trainer, Trainee, Unregistered로 구분되는 MemberTypeDTO
public enum MemberTypeResDTO: String, Decodable {
    case trainer = "TRAINER"
    case trainee = "TRAINEE"
    case unregistered = "UNREGISTERED"
    case unknown = ""
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = MemberTypeResDTO(rawValue: rawValue) ?? .unknown
    }
}

/// 회원 정보 응답 DTO
public struct PostSignUpResDTO: Decodable {
    /// 회원 타입 (trainer, trainee)
    let memberType: String
    /// 세션 ID
    let sessionId: String
    /// 회원 이름
    let name: String
    /// 프로필 이미지 URL
    let profileImageUrl: String
}

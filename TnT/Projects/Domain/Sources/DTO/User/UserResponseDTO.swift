//
//  UserResponseDTO.swift
//  Domain
//
//  Created by 박민서 on 1/25/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 로그인 세션 유효 확인 응답 DTO
public struct GetSessionCheckResDTO: Decodable {
    public let memberType: MemberTypeResDTO
}

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
    
    /// Coding Keys를 활용해 Decodable 처리
    enum CodingKeys: String, CodingKey {
        case sessionId
        case socialId
        case socialEmail
        case socialType
        case isSignUp
        case memberType
    }
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
    public let memberType: String
    /// 세션 ID
    public let sessionId: String
    /// 회원 이름
    public let name: String
    /// 프로필 이미지 URL
    public let profileImageUrl: String?
    
    public init(
        memberType: String,
        sessionId: String,
        name: String,
        profileImageUrl: String?
    ) {
        self.memberType = memberType
        self.sessionId = sessionId
        self.name = name
        self.profileImageUrl = profileImageUrl
    }
}

public enum MemberType: String, Decodable {
    case trainer = "TRAINER"
    case trainee = "TRAINEE"
    case unregistered = "UNREGISTERED"
    
    public init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "TRAINER":
            self = .trainer
        case "TRAINEE":
            self = .trainee
        case "UNREGISTERED":
            self = .unregistered
        default:
            return nil
        }
    }
}
    
/// 로그아웃 응답 DTO
public struct PostLogoutResDTO: Decodable {
    let sessionId: String
}

/// 회원탈퇴 응답 DTO
public typealias PostWithdrawalResDTO = EmptyResponse

/// 마이페이지 정보 응답 DTO
public struct GetMyPageInfoResDTO: Decodable {
    /// 회원 이름
    public let name: String
    /// 이메일
    public let email: String
    /// 프로필 사진 URL
    public let profileImageUrl: String
    /// 회원 타입
    public let memberType: MemberTypeResDTO
    /// 소셜 타입
    public let socialType: String
    /// 트레이너 DTO
    public let trainer: TrainerInfoResDTO?
    /// 트레이니 DTO
    public let trainee: TraineeInfoResDTO?
}

/// 트레이너 정보 표시에 사용되는 TrainerInfoDTO
public struct TrainerInfoResDTO: Decodable {
    /// 관리 중인 회원
    public let activeTraineeCount: Int?
    /// 함께했던 회원
    public let totalTraineeCount: Int?
}

/// 트레이니 정보 표시에 사용되는 TraineeInfoDTO
public struct TraineeInfoResDTO: Decodable {
    /// 트레이니 ID
    public let id: Int
    /// 트레이니 이름
    public let name: String
    /// 프로필 사진 URL
    public let profileImageUrl: String
    /// 진행한 PT 횟수
    public let finishedPtCount: Int
    /// 총 PT 횟수
    public let totalPtCount: Int
    /// 메모
    public let memo: String?
    /// PT 목표
    public let ptGoals: [String]
}

public extension PostSignUpResDTO {
    func toEntity() -> PostSignUpResEntity {
        return .init(
            memberType: self.memberType,
            sessionId: self.sessionId,
            name: self.name,
            profileImageUrl: self.profileImageUrl
        )
    }
}

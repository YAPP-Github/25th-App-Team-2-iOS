//
//  PostSocailEntity.swift
//  Domain
//
//  Created by 박서연 on 1/31/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

public enum SocialType: String {
    case kakao = "KAKAO"
    case apple = "APPLE"
}

/// 소셜 로그인 요청 DTO
public struct PostSocialEntity: Equatable {
    /// 소셜 로그인 타입 (KAKAO, APPLE)
    let socialType: SocialType
    /// FCM 토큰
    let fcmToken: String
    /// 소셜 액세스 토큰
    let socialAccessToken: String?
    /// 애플 ID 토큰 (Apple z로그인 시 필요)
    let idToken: String?
    
    public init(
        socialType: SocialType,
        fcmToken: String,
        socialAccessToken: String? = nil,
        idToken: String? = nil
    ) {
        self.socialType = socialType
        self.fcmToken = fcmToken
        self.socialAccessToken = socialAccessToken
        self.idToken = idToken
    }
}

/// 소셜 로그인 응답 DTO
public struct PostSocialLoginResEntity: Equatable {
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
}

/// 회원가입 요청 DTO
public struct PostSignUpEntity: Equatable {
    /// FCM 토큰
    public var fcmToken: String?
    /// 회원 타입 (trainer, trainee)
    public var memberType: UserType?
    /// 소셜 로그인 타입 (KAKAO, APPLE)
    public var socialType: SocialType?
    /// 소셜 로그인 ID
    public var socialId: String?
    /// 소셜 로그인 이메일
    public var socialEmail: String?
    /// 서비스 이용 약관 동의 여부
    public var serviceAgreement: Bool
    /// 개인정보 수집 동의 여부
    public var collectionAgreement: Bool
    /// 광고성 알림 수신 동의 여부
    public var advertisementAgreement: Bool
    /// 회원 이름
    public var name: String?
    /// 생년월일 (yyyy-MM-dd)
    public var birthday: String?
    /// 키 (cm)
    public var height: Double?
    /// 몸무게 (kg, 소수점 1자리까지 가능)
    public var weight: Double?
    /// 트레이너에게 전달할 주의사항
    public var cautionNote: String?
    /// PT 목적 (체중 감량, 근력 향상 등)
    public var goalContents: [String]?
    
    public init(
        fcmToken: String? = nil,
        memberType: UserType? = nil,
        socialType: SocialType? = nil,
        socialId: String? = nil,
        socialEmail: String? = nil,
        serviceAgreement: Bool = false,
        collectionAgreement: Bool = false,
        advertisementAgreement: Bool = false,
        name: String? = nil,
        birthday: String? = nil,
        height: Double? = nil,
        weight: Double? = nil,
        cautionNote: String? = nil,
        goalContents: [String]? = nil
    ) {
        self.fcmToken = fcmToken
        self.memberType = memberType
        self.socialType = socialType
        self.socialId = socialId
        self.socialEmail = socialEmail
        self.serviceAgreement = serviceAgreement
        self.collectionAgreement = collectionAgreement
        self.advertisementAgreement = advertisementAgreement
        self.name = name
        self.birthday = birthday
        self.height = height
        self.weight = weight
        self.cautionNote = cautionNote
        self.goalContents = goalContents
    }
}

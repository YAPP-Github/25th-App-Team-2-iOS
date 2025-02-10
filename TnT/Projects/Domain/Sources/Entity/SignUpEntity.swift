//
//  SignUpEntity.swift
//  Domain
//
//  Created by 박민서 on 2/8/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

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
    /// 프로필 이미지 데이터
    public var imageData: Data?
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
        imageData: Data? = nil,
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
        self.imageData = imageData
        self.birthday = birthday
        self.height = height
        self.weight = weight
        self.cautionNote = cautionNote
        self.goalContents = goalContents
    }
}

/// 회원가입 응답 DTO
public struct PostSignUpResEntity: Equatable, Sendable {
    /// 회원 타입 (trainer, trainee)
    public let memberType: String
    /// 세션 id
    public let sessionId: String
    /// 회원 이름
    public let name: String
    /// 프로필 이미지 URL
    public let profileImageUrl: String?
}

//
//  UserRequestDTO.swift
//  Domain
//
//  Created by 박민서 on 1/25/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 소셜 로그인 요청 DTO
public struct PostSocialLoginReqDTO: Encodable {
    /// 소셜 로그인 타입 (KAKAO, APPLE)
    let socialType: String
    /// FCM 토큰
    let fcmToken: String
    /// 소셜 액세스 토큰
    let socialAccessToken: String?
    /// 애플 인가 코드 (Apple 로그인 시 필요)
    let authorizationCode: String?
    /// 애플 ID 토큰 (Apple 로그인 시 필요)
    let idToken: String?
    
    public init(
        socialType: String,
        fcmToken: String,
        socialAccessToken: String?,
        authorizationCode: String?,
        idToken: String?
    ) {
        self.socialType = socialType
        self.fcmToken = fcmToken
        self.socialAccessToken = socialAccessToken
        self.authorizationCode = authorizationCode
        self.idToken = idToken
    }
}

/// 회원가입 요청 DTO
public struct PostSignUpReqDTO: Encodable {
    /// FCM 토큰
    let fcmToken: String
    /// 회원 타입 (trainer, trainee)
    let memberType: String
    /// 소셜 로그인 타입 (KAKAO, APPLE)
    let socialType: String
    /// 소셜 로그인 ID
    let socialId: String
    /// 소셜 로그인 이메일
    let socialEmail: String
    /// 서비스 이용 약관 동의 여부
    let serviceAgreement: Bool
    /// 개인정보 수집 동의 여부
    let collectionAgreement: Bool
    /// 광고성 알림 수신 동의 여부
    let advertisementAgreement: Bool
    /// 푸시 알림 수신 동의 여부
    let pushAgreement: Bool
    /// 회원 이름
    let name: String
    /// 생년월일 (yyyy-MM-dd)
    let birthday: String?
    /// 키 (cm)
    let height: Double?
    /// 몸무게 (kg, 소수점 1자리까지 가능)
    let weight: Double?
    /// 트레이너에게 전달할 주의사항
    let cautionNote: String?
    /// PT 목적 (체중 감량, 근력 향상 등)
    let goalContents: [String]?
    
    public init(
        fcmToken: String,
        memberType: String,
        socialType: String,
        socialId: String,
        socialEmail: String,
        serviceAgreement: Bool,
        collectionAgreement: Bool,
        advertisementAgreement: Bool,
        pushAgreement: Bool,
        name: String,
        birthday: String?,
        height: Double?,
        weight: Double?,
        cautionNote: String?,
        goalContents: [String]?
    ) {
        self.fcmToken = fcmToken
        self.memberType = memberType
        self.socialType = socialType
        self.socialId = socialId
        self.socialEmail = socialEmail
        self.serviceAgreement = serviceAgreement
        self.collectionAgreement = collectionAgreement
        self.advertisementAgreement = advertisementAgreement
        self.pushAgreement = pushAgreement
        self.name = name
        self.birthday = birthday
        self.height = height
        self.weight = weight
        self.cautionNote = cautionNote
        self.goalContents = goalContents
    }
}

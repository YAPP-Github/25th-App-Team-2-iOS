//
//  PostSocialMapper.swift
//  Domain
//
//  Created by 박서연 on 1/31/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

public extension PostSocialEntity {
    func toDTO() -> PostSocialLoginReqDTO {
        return .init(
            socialType: self.socialType.rawValue,
            fcmToken: self.fcmToken,
            socialAccessToken: self.socialAccessToken,
            idToken: self.idToken
        )
    }
}

public extension PostSocialLoginResDTO {
    func toEntity() -> PostSocialLoginResEntity {
        return .init(
            sessionId: self.sessionId,
            socialId: self.socialId,
            socialEmail: self.socialEmail,
            socialType: self.socialType,
            isSignUp: self.isSignUp,
            membertype: self.memberType
        )
    }
}

public extension PostSignUpEntity {
    func toDTO() -> PostSignUpReqDTO? {
        guard let memberType, let socialType, let socialId, let socialEmail, let name else { return nil }
        return .init(
            // TODO: FCM 서버 로직 나오면 수정
            fcmToken: self.fcmToken ?? "temp",
            memberType: memberType.englishName,
            socialType: socialType.rawValue,
            socialId: socialId,
            socialEmail: socialEmail,
            serviceAgreement: self.serviceAgreement,
            collectionAgreement: self.collectionAgreement,
            advertisementAgreement: self.advertisementAgreement,
            name: name,
            birthday: self.birthday?.replacingOccurrences(of: "/", with: "-"),
            height: self.height,
            weight: self.weight,
            cautionNote: self.cautionNote,
            goalContents: self.goalContents ?? []
        )
    }
    
    /// `PostSocialLoginResDTO` → `PostSocialLoginResEntity` 변환
    static func toResEntity(from dto: PostSocialLoginResDTO) -> PostSocialLoginResEntity {
        return PostSocialLoginResEntity(
            sessionId: dto.sessionId,
            socialId: dto.socialId,
            socialEmail: dto.socialEmail,
            socialType: dto.socialType,
            isSignUp: dto.isSignUp,
            membertype: dto.memberType
        )
    }
}

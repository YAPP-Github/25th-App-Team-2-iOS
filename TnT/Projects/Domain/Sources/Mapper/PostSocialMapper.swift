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
            isSignUp: self.isSignUp
        )
    }
}

public extension PostSignUpEntity {
    func toDTO() -> PostSignUpReqDTO? {
        guard let memberType, let socialType, let socialId, let socialEmail, let name, let goalContents else { return nil }
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
            birthday: self.birthday,
            height: self.height,
            weight: self.weight,
            cautionNote: self.cautionNote,
            goalContents: goalContents
        )
    }
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

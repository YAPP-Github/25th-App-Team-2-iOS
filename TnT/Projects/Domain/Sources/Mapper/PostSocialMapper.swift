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

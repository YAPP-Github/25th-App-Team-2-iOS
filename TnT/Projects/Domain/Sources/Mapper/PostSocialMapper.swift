//
//  PostSocialMapper.swift
//  Domain
//
//  Created by 박서연 on 1/31/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

public struct PostSocialMapper {
    public static func toDTO(from entity: PostSocailEntity) -> PostSocialLoginReqDTO {
        return PostSocialLoginReqDTO(
            socialType: entity.socialType,
            fcmToken: entity.fcmToken,
            socialAccessToken: entity.socialAccessToken,
            authorizationCode: entity.authorizationCode,
            idToken: entity.idToken
        )
    }
    
    public static func toEntity(from dto: PostSocialLoginReqDTO) -> PostSocailEntity {
        return PostSocailEntity(
            socialType: dto.socialType,
            fcmToken: dto.fcmToken,
            socialAccessToken: dto.socialAccessToken,
            authorizationCode: dto.authorizationCode,
            idToken: dto.idToken
        )
    }
}

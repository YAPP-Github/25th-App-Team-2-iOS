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
    
    /// `PostSocialLoginResDTO` → `PostSocialLoginResEntity` 변환
    public static func toResEntity(from dto: PostSocialLoginResDTO) -> PostSocialLoginResEntity {
        return PostSocialLoginResEntity(
            sessionId: dto.sessionId,
            socialId: dto.socialId,
            socialEmail: dto.socialEmail,
            socialType: dto.socialType,
            isSignUp: dto.isSignUp
        )
    }
    
    /// `PostSocialLoginResEntity` → `PostSocialLoginResDTO` 변환
    public static func toDTO(from entity: PostSocialLoginResEntity) -> PostSocialLoginResDTO {
            return PostSocialLoginResDTO(
                sessionId: entity.sessionId,
                socialId: entity.socialId,
                socialEmail: entity.socialEmail,
                socialType: entity.socialType,
                isSignUp: entity.isSignUp
            )
        }
}

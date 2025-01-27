//
//  OAuthDTO.swift
//  Domain
//
//  Created by 박민서 on 1/26/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 카카오 로그인 요청 DTO
public struct KakaoLoginInfo: Codable {
    public let accessToken: String
    public let socialRefreshToken: String
    
    public init(accessToken: String, socialRefreshToken: String) {
        self.accessToken = accessToken
        self.socialRefreshToken = socialRefreshToken
    }
}

/// 애플 로그인 요청 DTO
public struct AppleLoginInfo: Codable {
    public let identityToken: String
    public let authorizationCode: String
    
    public init(identityToken: String, authorizationCode: String) {
        self.identityToken = identityToken
        self.authorizationCode = authorizationCode
    }
}

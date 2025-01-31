//
//  SocialLogInRepositoryImpl.swift
//  Data
//
//  Created by 박서연 on 1/29/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation
import Dependencies

import Domain

public enum LoginError: Error {
    case invalidCredentials
    case networkFailure
    case kakaoError
    case appleError
    case unknown(message: String)
}

public struct SocialLogInRepositoryImpl: SocialLoginRepository {
    
    public let loginManager: SNSLoginManager
    
    public init(loginManager: SNSLoginManager) {
        self.loginManager = loginManager
    }

    public func appleLogin() async -> AppleLoginInfo? {
        let result = await loginManager.appleLogin()
        
        return result
    }
    
    public func kakaoLogin() async -> KakaoLoginInfo? {
        let result = await loginManager.kakaoLogin()
        return result
    }
    
    public func kakaoLogout() async {
        // 미구현
    }
    
//    public func appleLoginResult() async throws -> Result<PostSocialLoginReqDTO, Error> {
//        let result = await loginManager.appleLogin()
//        
//        guard let result else {
//            return .failure(LoginError.appleError)
//        }
//        
//        let appleRequest = PostSocialLoginReqDTO(
//            socialType: "APPLE",
//            fcmToken: "",
//            socialAccessToken: "",
//            authorizationCode: result.authorizationCode,
//            idToken: result.identityToken
//        )
//        
//        return .success(appleRequest)
//    }
//    
//    public func kakaoLoginResult() async throws -> Result<PostSocialLoginReqDTO, Error> {
//        let result = await loginManager.kakaoLogin()
//        
//        guard let result else {
//            return .failure(LoginError.kakaoError)
//        }
//        
//        let kakaoRequest = PostSocialLoginReqDTO(
//            socialType: "KAKAO",
//            fcmToken: "",
//            socialAccessToken: result.accessToken,
//            authorizationCode: "",
//            idToken: ""
//        )
//        
//        return .success(kakaoRequest)
//    }
}

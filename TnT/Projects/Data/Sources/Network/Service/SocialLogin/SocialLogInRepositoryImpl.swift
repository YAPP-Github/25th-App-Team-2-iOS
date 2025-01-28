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

//public struct SocialLogInRepositoryImpl: UserRepository {
//    
//    public let loginManager = SNSLoginManager()
//    
//    public init() {}
//
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
//    
//    public func postSocialLogin(_ reqDTO: Domain.PostSocialLoginReqDTO) async throws -> PostSocialLoginResDTO {
//        
//    }
//    
//    public func postSignUp(_ reqDTO: Domain.PostSignUpReqDTO, profileImage: Data?) async throws -> PostSignUpResDTO {
//        <#code#>
//    }    
//}

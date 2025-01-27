//
//  UserRepositoryImpl.swift
//  Data
//
//  Created by 박민서 on 1/25/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation
import Dependencies

import Domain

/// 사용자 관련 네트워크 요청을 처리하는 UserRepository 구현체
public struct UserRepositoryImpl: UserRepository {
    
    private let networkService: NetworkService = .shared
    
    public init() {}
    
    /// 소셜 로그인 요청을 수행
    public func postSocialLogin(_ reqDTO: PostSocialLoginReqDTO) async throws -> PostSocialLoginResDTO {
        return try await networkService.request(
            UserTargetType.postSocialLogin(reqDTO: reqDTO),
            decodingType: PostSocialLoginResDTO.self
        )
    }
    
    /// 회원가입 요청을 수행
    public func postSignUp(_ reqDTO: PostSignUpReqDTO, profileImage: Data?) async throws -> PostSignUpResDTO {
        return try await networkService.request(
            UserTargetType.postSignUp(
                reqDTO: reqDTO,
                imgData: profileImage
            ),
            decodingType: PostSignUpResDTO.self
        )
    }
}

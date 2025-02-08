//
//  UserRepository.swift
//  Domain
//
//  Created by 박민서 on 1/25/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 사용자 관련 데이터를 관리하는 UserRepository 프로토콜
/// - 실제 네트워크 요청은 이 인터페이스를 구현한 `UserRepositoryImpl`에서 수행됩니다.
public protocol UserRepository {
    /// 로그인 세션 유효 확인
    /// - Returns: 세션 유효 시, 멤버 타입 정보를 포함한 응답 DTO (`GetSessionCheckResDTO`)
    /// - Throws: 네트워크 오류 또는 서버에서 반환한 오류를 발생시킬 수 있음
    func getSessionCheck() async throws -> GetSessionCheckResDTO
    
    /// 소셜 로그인 요청
    /// - Parameter reqDTO: 소셜 로그인 요청에 필요한 데이터 (액세스 토큰 등)
    /// - Returns: 로그인 성공 시, 사용자 정보를 포함한 응답 DTO (`PostSocialLoginResDTO`)
    /// - Throws: 네트워크 오류 또는 서버에서 반환한 오류를 발생시킬 수 있음
    func postSocialLogin(_ reqDTO: PostSocialLoginReqDTO) async throws -> PostSocialLoginResDTO
    
    /// 회원가입 요청
    /// - Parameters:
    ///   - reqDTO: 회원가입 요청에 필요한 데이터 (이름, 생년월일, 키, 몸무게 등)
    ///   - profileImage: 사용자가 업로드한 프로필 이미지 (옵션)
    /// - Returns: 회원가입 성공 시, 사용자 정보를 포함한 응답 DTO (`PostSignUpResDTO`)
    /// - Throws: 네트워크 오류 또는 서버에서 반환한 오류를 발생시킬 수 있음
    func postSignUp(_ reqDTO: PostSignUpReqDTO, profileImage: Data?) async throws -> PostSignUpResDTO
}

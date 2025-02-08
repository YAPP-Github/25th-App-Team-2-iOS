//
//  UserTargetType.swift
//  Data
//
//  Created by 박민서 on 1/25/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

import Domain

/// 사용자 관련 API 요청 타입 정의
public enum UserTargetType {
    /// 로그인 세션 유효 확인
    case getSessionCheck
    /// 소셜 로그인 요청
    case postSocialLogin(reqDTO: PostSocialLoginReqDTO)
    /// 회원가입 요청
    case postSignUp(reqDTO: PostSignUpReqDTO, imgData: Data?)
}

extension UserTargetType: TargetType {
    var baseURL: URL {
        return URL(string: Config.apiBaseUrlDev)!
    }
    
    var path: String {
        switch self {
        case .getSessionCheck:
            return "/check-session"
            
        case .postSocialLogin:
            return "/login"
            
        case .postSignUp:
            return "/members/sign-up"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getSessionCheck:
            return .get
            
        case .postSocialLogin, .postSignUp:
            return .post
        }
    }
    
    var task: RequestTask {
        switch self {
        case .getSessionCheck:
            return .requestPlain
        
        case .postSocialLogin(let reqDto):
            return .requestJSONEncodable(encodable: reqDto)
            
        case let .postSignUp(reqDto, imgData):
            let jsons: [MultipartJSON] = [.init(jsonName: "request", json: reqDto)]
            
            // 프로필 이미지가 있을 경우 멀티파트 업로드 처리
            let files: [MultipartFile] = imgData.map {
                [.init(fieldName: "profileImage", fileName: "profile.png", mimeType: "image/png", data: $0)]
            } ?? []
            
            return .uploadMultipart(jsons: jsons, files: files, additionalFields: [:])
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getSessionCheck:
            return nil
            
        case .postSocialLogin:
            return ["Content-Type": "application/json"]
            
        case .postSignUp:
            return [
                "Content-Type": "multipart/form-data",
                "Authorization": "SESSION-ID 1111"
            ]
        }
    }
    
    var interceptors: [any Interceptor] {
        switch self {
        case .getSessionCheck:
            return [
                LoggingInterceptor(),
                AuthTokenInterceptor(),
                ResponseValidatorInterceptor(),
                RetryInterceptor(maxRetryCount: 2)
            ]
        default:
            return [
                LoggingInterceptor(),
                ResponseValidatorInterceptor(),
                RetryInterceptor(maxRetryCount: 2)
            ]
        }
    }
}

//
//  LoginFeature.swift
//  Presentation
//
//  Created by 박서연 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

import Domain
import DIContainer

@Reducer
public struct LoginFeature {
    @ObservableState
    public struct State: Equatable {
        public var userType: UserType?
        public var nickname: String?
        public var socialType: LoginType?
        public var termAgree: Bool
        public var socialEmail: String?
        public var postUserEntity: PostSocailEntity?
        
        public init(
            userType: UserType? = nil,
            nickname: String? = nil,
            socialType: LoginType? = nil,
            termAgree: Bool = false,
            socialEmail: String? = nil,
            postUserEntity: PostSocailEntity? = nil
        ) {
            self.userType = userType
            self.nickname = nickname
            self.socialType = socialType
            self.termAgree = termAgree
            self.socialEmail = socialEmail
            self.postUserEntity = postUserEntity
        }
    }
    
    @Dependency(\.userUseCase) private var userUseCase: UserUseCase
    @Dependency(\.userUseRepoCase) private var userUseCaseRepo: UserRepository
    @Dependency(\.socialLogInUseCase) private var socialLoginUseCase: SocialLoginUseCase
    
    public enum Action: ViewAction {
        /// 뷰에서 일어나는 액션을 처리합니다.(카카오,애플로그인 실행)
        case view(View)
        /// 네비게이션 여부 설정
        case setNavigating(RoutingScreen)
        /// 소셜 로그인 post 요청
        case postSocialLogin(entity: PostSocailEntity)
        /// 소셜 로그인 실패
        case socialLoginFail
        
        @CasePathable
        public enum View: Equatable {
            case tappedAppleLogin
            case tappedKakaoLogin
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(view):
                switch view {
                case .tappedAppleLogin:
                    return .run { @Sendable send in
                        let result = await socialLoginUseCase.appleLogin()
                        guard let result else { return }
                        let entity = PostSocailEntity(
                            socialType: "APPLE",
                            fcmToken: "",
                            socialAccessToken: "",
                            authorizationCode: result.authorizationCode,
                            idToken: result.identityToken
                        )
                        
                        await send(.postSocialLogin(entity: entity))
                    }
                    
                case .tappedKakaoLogin:
                    return .run { @Sendable send in
                        let result = await socialLoginUseCase.kakaoLogin()
                        guard let result else { return }
                        
                        let entity = PostSocailEntity(
                            socialType: "KAKAO",
                            fcmToken: "",
                            socialAccessToken: result.accessToken,
                            authorizationCode: "",
                            idToken: ""
                        )
                        
                        await send(.postSocialLogin(entity: entity))
                    }
                }
                
            case .postSocialLogin(let entity):
                let post = PostSocialMapper.toDTO(from: entity)
                return .run { send in
                    do {
                        let result = try await userUseCaseRepo.postSocialLogin(post)
                        // TODO: res에 MemberType 추가해주세요!
//                            switch result.memberType {
//                            case .trainer:
//                                await send(.setNavigating(.trainerHome))
//                            case .trainee:
//                                await send(.setNavigating(.traineeHome))
//                            case .unregistered:
//                                await send(.setNavigating(.term))
//                            }
                        // For test
                        await send(.setNavigating(.term))
                    } catch {
                        await send(.socialLoginFail)
                    }
                }
                
            case .socialLoginFail:
                print("네트워크 에러 발생")
                return .none
                
            case .setNavigating:
                return .none
            }
        }
    }
}

extension LoginFeature {
    /// 본 화면에서 라우팅(파생)되는 화면
    public enum RoutingScreen {
        case traineeHome
        case trainerHome
        case term
    }
}

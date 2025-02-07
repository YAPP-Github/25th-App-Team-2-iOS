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
        public var postUserEntity: PostSocialEntity?
        @Presents var termFeature: TermFeature.State?
        
        public init(
            userType: UserType? = nil,
            nickname: String? = nil,
            socialType: LoginType? = nil,
            termAgree: Bool = false,
            socialEmail: String? = nil,
            postUserEntity: PostSocialEntity? = nil
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
        /// 하위 화면에서 일어나는 액션을 처리합니다
        case subFeature(SubFeatureAction)
        /// 네비게이션 여부 설정
        case setNavigating(RoutingScreen)
        /// 소셜 로그인 post 요청
        case postSocialLogin(entity: PostSocialEntity)
        /// 소셜 로그인 실패
        case socialLoginFail
        /// 약관 동의 화면 표시
        case showTermView
        
        @CasePathable
        public enum View: Equatable {
            case tappedAppleLogin
            case tappedKakaoLogin
        }
        
        @CasePathable
        public enum SubFeatureAction: Equatable {
            /// 역관 동의 화면에서 발생하는 액션 처리
            case termAction(PresentationAction<TermFeature.Action>)
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
                        
                        let entity = PostSocialEntity(
                            socialType: .apple,
                            fcmToken: "asdfg", // TODO: FCM 로직 나오면 추후 수정
                            idToken: result.identityToken
                        )
                        
                        await send(.postSocialLogin(entity: entity))
                    }
                    
                case .tappedKakaoLogin:
                    return .run { @Sendable send in
                        let result = await socialLoginUseCase.kakaoLogin()
                        guard let result else { return }
                        
                        let entity = PostSocialEntity(
                            socialType: .kakao,
                            fcmToken: "asdfg", // TODO: FCM 로직 나오면 추후 수정
                            socialAccessToken: result.accessToken
                        )
                        
                        await send(.postSocialLogin(entity: entity))
                    }
                }
                
            case .subFeature(.termAction(.presented(.setNavigating))):
                state.termFeature = nil
                return .send(.setNavigating(.userTypeSelection))
            
            case .subFeature(.termAction(.dismiss)):
                state.termFeature = nil
                return .none
                
            case .subFeature:
                return .none
                
            case .postSocialLogin(let entity):
                let post = entity.toDTO()
                return .run { send in
                    do {
                        let result = try await userUseCaseRepo.postSocialLogin(post)
                        switch result.memberType {
                        case .trainer:
                            await send(.setNavigating(.trainerHome))
                        case .trainee:
                            await send(.setNavigating(.traineeHome))
                        case .unregistered:
                            await send(.showTermView)
                        case .unknown:
                            print("unknown 타입이에요 토스트해줏요")
                        }
                    } catch {
                        await send(.socialLoginFail)
                    }
                }
                
            case .socialLoginFail:
                print("네트워크 에러 발생")
                return .none
                
            case .showTermView:
                state.termFeature = .init()
                return .none
                
            case .setNavigating:
                return .none
            }
        }
        .ifLet(\.termFeature, action: \.subFeature.termAction.presented) {
            TermFeature()
        }
    }
}

extension LoginFeature {
    /// 본 화면에서 라우팅(파생)되는 화면
    public enum RoutingScreen {
        case traineeHome
        case trainerHome
        case userTypeSelection
    }
}

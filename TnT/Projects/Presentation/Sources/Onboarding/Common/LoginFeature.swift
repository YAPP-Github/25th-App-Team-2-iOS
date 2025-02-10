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
        @Shared var signUpEntity: PostSignUpEntity
        public var postUserEntity: PostSocialEntity?
        @Presents var termFeature: TermFeature.State?
        
        public init(
            signUpEntity: Shared<PostSignUpEntity>,
            postUserEntity: PostSocialEntity? = nil
        ) {
            self._signUpEntity = signUpEntity
            self.postUserEntity = postUserEntity
        }
    }
    
    @Dependency(\.userUseCase) private var userUseCase: UserUseCase
    @Dependency(\.userUseRepoCase) private var userUseCaseRepo: UserRepository
    @Dependency(\.socialLogInUseCase) private var socialLoginUseCase: SocialLoginUseCase
    @Dependency(\.keyChainManager) var keyChainManager
    
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
        /// signUpEntity를 소셜로그인 정보로 업데이트
        case updateSignUpEntityWithSocialInfo(res: PostSocialLoginResDTO)
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
                state.$signUpEntity.withLock { $0.collectionAgreement = true }
                state.$signUpEntity.withLock { $0.serviceAgreement = true }
                state.$signUpEntity.withLock { $0.advertisementAgreement = true }
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
                        saveSessionId(result.sessionId)
                        
                        switch result.memberType {
                        case .trainer:
                            await send(.setNavigating(.trainerHome))
                        case .trainee:
                            await send(.setNavigating(.traineeHome))
                        case .unregistered:
                            await send(.updateSignUpEntityWithSocialInfo(res: result))
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
                
            case .updateSignUpEntityWithSocialInfo(let res):
                guard let socialType = SocialType(rawValue: res.socialType ?? "") else { return .none }
                state.$signUpEntity.withLock { $0.socialId = res.socialId }
                state.$signUpEntity.withLock { $0.socialEmail = res.socialEmail }
                state.$signUpEntity.withLock { $0.socialType = socialType }
                return .send(.showTermView)
                
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
    private func saveSessionId(_ sessionId: String?) {
        guard let sessionId else { return }
        do {
            try keyChainManager.save(sessionId, for: .sessionId)
        } catch {
            print("로그인 정보 저장 싪패")
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

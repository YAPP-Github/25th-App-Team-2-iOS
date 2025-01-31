//
//  OnboardingFeature.swift
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
public struct OnboardingFeature {
    @ObservableState
    public struct State: Equatable {
        public var path = StackState<Path.State>()
        public var userType: UserType?
        public var nickname: String? = ""
        public var socialType: LoginType?
        public var termAgree: Bool = true
        public var socialEmail: String? = ""
        public var postUserEntity: PostSocailEntity?
        
        public init(path: StackState<Path.State> = StackState<Path.State>()) {
            self.path = path
        }
    }
    
    @Dependency(\.userUseCase) private var userUseCase: UserUseCase
    @Dependency(\.userUseRepoCase) private var userUseCaseRepo: UserRepository
    @Dependency(\.socialLogInUseCase) private var socialLoginUseCase: SocialLoginUseCase
    
    public enum Action: ViewAction {
        /// 뷰에서 일어나는 액션을 처리합니다.(카카오,애플로그인 실행)
        case view(View)
        /// 뷰를 이동할때 일어나는 액션을 처리합니다. 
        /// 기존 ViewAction을 Root임을 고려하여 MoveAction으로 구현하였습니다.
        case move(MoveAction)
        case path(StackActionOf<Path>)
        
        @CasePathable
        public enum View: Equatable {
            case tappedAppleLogin
            case tappedKakaoLogin
            case postSocialLogin(entity: PostSocailEntity)
            case postSignUp
            case socailLoginFail
        }
        
        @CasePathable
        public enum MoveAction: Equatable {
            /// 약관 동의 화면으로 이동
            case toTermview
            /// 역할 선택화면으로 이동
            case toselectRole
            /// 이름 입력 화면으로 이동(트레이너/트레이니 공통 화면)
            case toRegisterNickname
            /// 회원가입 완료 화면으로 이동(트레이너/트레이니 공통 화면)
            case toCompleteSignup
            /// 트레이너의 초대코드 발급 화면으로 이동
            case toMakeInvitationCode
            /// 트레이니의 기본 정보 입력 화면으로 이동
            case toRegisterUserInfo
            /// 트레이니의 pt 수강 목적 입력화면으로 이동
            case toRegisterPtPurpose
            /// 트레이니의 주의사항 입력화면으로 이동
            case toRegisterprecautions
            /// 트레이니의 초대코드 입력화면으로 이동
            case toRegisterInvitationCode
            /// 트레이니의 pt 횟수 및 정보 입력화면으로 이동
            case toRegisterPtClassInfo
            /// 홈으로 이동
            case toHome
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
                        
                        await send(.view(.postSocialLogin(entity: entity)))
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
                        
                        await send(.view(.postSocialLogin(entity: entity)))
                    }
                    
                case .postSocialLogin:
                    guard let postEntity = state.postUserEntity else { return .none }
                    let entity = PostSocialMapper.toDTO(from: postEntity)
                    
                    return .run { send in
                        do {
                            let result = try await userUseCaseRepo.postSocialLogin(entity)
                            await send(.move(.toHome))
                        } catch {
                            await send(.move(.toTermview))
                        }
                    }
                    
                case .socailLoginFail:
                    return .none
                    
                case .postSignUp:
                    return .none
                }
                
            case let .move(move):
                switch move {
                case .toTermview:
                    state.path.append(.term(TermFeature.State()))
                    return .none
                case .toselectRole:
                    state.path.append(.selectRole)
                    return .none
                case .toRegisterNickname:
                    state.path.append(.registerNickname)
                    return .none
                case .toCompleteSignup:
                    state.path.append(.completeSignup(TrainerSignUpCompleteFeature.State()))
                    return .none
                case .toMakeInvitationCode:
                    state.path.append(.makeInvitationCode(MakeInvitationCodeFeature.State()))
                    return .none
                case .toHome:
                    print("post 사인 성공..")
                    return .none
                default:
                    return .none
                }
                
            case let .path(action):
                switch action {
                
                /// 트레이너 프로필 생성 완료 -> 다음 버튼 tapped
                case .element(id: _, action: .completeSignup(.setNavigating)):
                    state.path.append(.makeInvitationCode(MakeInvitationCodeFeature.State()))
                    return .none
                
                /// 트레이너의 초대코드 화면 -> 건너뛰기 버튼 tapped
                case .element(id: _, action: .makeInvitationCode(.setNavigation)):
                    // 추후에 홈과 연결
                    return .none
                    
                ///  약관 화면 -> 트레이너/트레이니 선택 화면 이동
                case .element(id: _, action: .selectRole):
                    return .none
                    
                default:
                    return .none
                }
            }
        }
        .forEach(\.path, action: \.path)
    }
    
    @Reducer(state: .equatable)
    public enum Path {
        /// 약관동의뷰
        case term(TermFeature)
        /// 트레이너/트레이니 선택 뷰
        case selectRole
        /// 트레이너/트레이니의 이름 입력 뷰
        case registerNickname
        /// 트레이너/트레이니 회원가입 완료 뷰
        case completeSignup(TrainerSignUpCompleteFeature)
        /// 트레이너의 초대코드 발급 뷰
        case makeInvitationCode(MakeInvitationCodeFeature)
        /// 트레이니 기본 정보 입력
        case registerUserInfo
        /// 트레이니 PT 목적 입력
        case registerPtPurpose
        /// 트레이니 주의사항 입력
        case registerPrecautions
        /// 트레이니 코드입력
        case registerInvitationCode
        /// 트레이니 수업 정보 입력
        case registerPtClassInfo
        /// 홈
        case home
    }
}

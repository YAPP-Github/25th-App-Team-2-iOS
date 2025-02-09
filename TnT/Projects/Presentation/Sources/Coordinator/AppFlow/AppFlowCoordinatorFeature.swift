//
//  AppFlowCoordinatorFeature.swift
//  Presentation
//
//  Created by 박민서 on 2/4/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import Domain
import DIContainer

public enum AppFlow: Sendable {
    case onboardingFlow
    case traineeMainFlow
    case trainerMainFlow
}

@Reducer
public struct AppFlowCoordinatorFeature {
    @ObservableState
    public struct State: Equatable {
        // MARK: Data related state
        var userType: UserType?
        // MARK: UI related state
        var view_isSplashActive: Bool
        
        // MARK: SubFeature state
        var trainerMainState: TrainerMainFlowFeature.State?
        var traineeMainState: TraineeMainFlowFeature.State?
        var onboardingState: OnboardingFlowFeature.State?
        
        public init(
            userType: UserType? = nil,
            view_isSplashActive: Bool = true,y
            onboardingState: OnboardingFlowFeature.State? = nil,
            trainerMainState: TrainerMainFlowFeature.State? = nil,
            traineeMainState: TraineeMainFlowFeature.State? = nil
        ) {
            self.userType = userType
            self.view_isSplashActive = view_isSplashActive
            self.onboardingState = onboardingState
            self.trainerMainState = trainerMainState
            self.traineeMainState = traineeMainState
        }
    }

    public enum Action {
        /// 하위 코디네이터에서 일어나는 액션을 처리합니다
        case subFeature(SubFeatureAction)
        /// api 콜 액션을 처리합니다
        case api(APIAction)
        /// 저장 세션 정보 확인
        case checkSessionInfo
        /// 현재 유저 정보 업데이트
        case updateUserInfo(UserType?)
        /// 스플래시 표시 종료 시
        case splashFinished
        /// 첫 진입 시
        case onAppear
        
        @CasePathable
        public enum SubFeatureAction: Sendable {
            /// 온보딩 플로우 코디네이터에서 발생하는 액션 처리
            case onboardingFlow(OnboardingFlowFeature.Action)
            /// 트레이너 메인탭 플로우 코디네이터에서 발생하는 액션 처리
            case trainerMainFlow(TrainerMainFlowFeature.Action)
            /// 트레이니 메인탭 플로우 코디네이터에서 발생하는 액션 처리
            case traineeMainFlow(TraineeMainFlowFeature.Action)
        }
        
        @CasePathable
        public enum APIAction: Sendable {
            /// 로그인 세션 유효 확인 API
            case checkSession
        }
    }
    
    @Dependency(\.userUseRepoCase) private var userUseCaseRepo: UserRepository
    @Dependency(\.keyChainManager) private var keyChainManager
    
    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .subFeature(let internalAction):
                switch internalAction {
                case .onboardingFlow(.switchFlow(let flow)),
                        .traineeMainFlow(.switchFlow(let flow)),
                        .trainerMainFlow(.switchFlow(let flow)):
                    return self.setFlow(flow, state: &state)
                default:
                    return .none
                }
            
            case .api(let action):
                switch action {
                case .checkSession:
                    return .run { send in
                        let result = try? await userUseCaseRepo.getSessionCheck()
                        switch result?.memberType {
                        case .trainer:
                            await send(.updateUserInfo(.trainer))
                        case .trainee:
                            await send(.updateUserInfo(.trainee))
                        default:
                            try keyChainManager.delete(.sessionId)
                            await send(.updateUserInfo(nil))
                        }
                    }
                }
            
            case .checkSessionInfo:
                let session: String? = try? keyChainManager.read(for: .sessionId)
                return session != nil
                ? .send(.api(.checkSession))
                : .send(.updateUserInfo(nil))
                
            case .updateUserInfo(let userType):
                switch userType {
                case .trainee:
                    return self.setFlow(.traineeMainFlow, state: &state)
                case .trainer:
                    return self.setFlow(.trainerMainFlow, state: &state)
                default:
                    return self.setFlow(.onboardingFlow, state: &state)
                }
                
            case .splashFinished:
                state.view_isSplashActive = false
                return .none
                
            case .onAppear:
                return .merge(
                    .run { send in
                        try await Task.sleep(for: .seconds(1))
                        await send(.splashFinished)
                    },
                    .send(.checkSessionInfo)
                )
            }
        }
        .ifLet(\.onboardingState, action: \.subFeature.onboardingFlow) { OnboardingFlowFeature() }
        .ifLet(\.trainerMainState, action: \.subFeature.trainerMainFlow) { TrainerMainFlowFeature() }
        .ifLet(\.traineeMainState, action: \.subFeature.traineeMainFlow) { TraineeMainFlowFeature() }
    }
}

extension AppFlowCoordinatorFeature {
    /// 앱의 흐름을 조절합니다
    /// 선택된 플로우에 따라 유저타입도 분기처리됩니다
    private func setFlow(_ flow: AppFlow, state: inout State) -> Effect<Action> {
        state.onboardingState = nil
        state.traineeMainState = nil
        state.trainerMainState = nil
        
        switch flow {
        case .onboardingFlow:
            state.userType = nil
            state.onboardingState = .init()
        case .traineeMainFlow:
            state.userType = .trainee
            state.traineeMainState = .init()
        case .trainerMainFlow:
            state.userType = .trainer
            state.trainerMainState = .init()
        }
        
        return .none
    }
}

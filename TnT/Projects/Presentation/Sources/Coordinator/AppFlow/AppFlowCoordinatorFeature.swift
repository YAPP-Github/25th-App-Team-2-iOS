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
    case onboardingFlow(OnboardingFlowFeature.State)
    case traineeMainFlow(TraineeMainFlowFeature.State)
    case trainerMainFlow(TrainerMainFlowFeature.State)
}

@Reducer
public struct AppFlowCoordinatorFeature {
    @ObservableState
    public struct State: Equatable {
        // MARK: Data related state
        /// 트레이너/트레이니 연결 여부
        @Shared(.appStorage(AppStorage.isConnected)) var isConnected: Bool = false
        /// 유저 멤버 유형
        var userType: UserType?
        // MARK: UI related state
        /// 스플래시 표시 여부
        var view_isSplashActive: Bool
        /// 팝업 표시 여부
        var view_isPopUpPresented: Bool
        
        // MARK: SubFeature state
        var trainerMainState: TrainerMainFlowFeature.State?
        var traineeMainState: TraineeMainFlowFeature.State?
        var onboardingState: OnboardingFlowFeature.State?
        
        public init(
            userType: UserType? = nil,
            view_isSplashActive: Bool = true,
            view_isPopUpPresented: Bool = false,
            onboardingState: OnboardingFlowFeature.State? = nil,
            trainerMainState: TrainerMainFlowFeature.State? = nil,
            traineeMainState: TraineeMainFlowFeature.State? = nil
        ) {
            self.userType = userType
            self.view_isSplashActive = view_isSplashActive
            self.view_isPopUpPresented = view_isPopUpPresented
            self.onboardingState = onboardingState
            self.trainerMainState = trainerMainState
            self.traineeMainState = traineeMainState
        }
    }

    public enum Action: ViewAction {
        case view(View)
        /// 하위 코디네이터에서 일어나는 액션을 처리합니다
        case subFeature(SubFeatureAction)
        /// api 콜 액션을 처리합니다
        case api(APIAction)
        /// 저장 세션 정보 확인
        case checkSessionInfo
        /// 현재 유저 정보 업데이트
        case updateUserInfo(type: UserType?, isConnected: Bool)
        /// 스플래시 표시 종료 시
        case splashFinished
        
        @CasePathable
        public enum View: Sendable, BindableAction {
            /// 바인딩할 액션을 처리
            case binding(BindingAction<State>)
            /// 첫 진입 시
            case onAppear
            /// 세션 만료 팝업 확인 버튼 탭
            case tapSessionExpiredPopupConfirmButton
            /// Notification 액션 처리
            case notification(NotificationAction)
        }
        
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
        
        @CasePathable
        public enum NotificationAction: Sendable {
            /// 세션 만료 팝업 표시
            case showSessionExpiredPopup
            /// 트레이너/트레이니 연결 완료 알림 탭 시
            case showConnectCompletion(trainerId: Int64, traineeId: Int64)
        }
    }
    
    @Dependency(\.userUseRepoCase) private var userUseCaseRepo: UserRepository
    @Dependency(\.keyChainManager) private var keyChainManager
    
    public init() {}

    public var body: some Reducer<State, Action> {
        BindingReducer(action: \.view)
        
        Reduce { state, action in
            switch action {
            case .view(let action):
                switch action {
                case .binding:
                    return .none
                    
                case .onAppear:
                    return .merge(
                        .run { send in
                            try await Task.sleep(for: .seconds(1))
                            await send(.splashFinished)
                        },
                        .send(.checkSessionInfo)
                    )
                    
                case .tapSessionExpiredPopupConfirmButton:
                    state.view_isPopUpPresented = false
                    return self.setFlow(.onboardingFlow(.init()), state: &state)
                    
                case .notification(let action):
                    switch action {
                    case .showSessionExpiredPopup:
                        state.view_isPopUpPresented = true
                        return .none
                        
                    case let .showConnectCompletion(trainerId, traineeId):
                        return self.setFlow(.trainerMainFlow(.init(path:
                                .init([
                                    .mainTab(.home(.init())),
                                    .connectionComplete(.init(traineeId: traineeId, trainerId: trainerId))
                                ])
                        )), state: &state)
                    }
                }
                
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
                        guard let result = try? await userUseCaseRepo.getSessionCheck() else {
                            try keyChainManager.delete(.sessionId)
                            await send(.updateUserInfo(type: nil, isConnected: false))
                            return
                        }
                        
                        switch result.memberType {
                        case .trainer:
                            await send(.updateUserInfo(type: .trainer, isConnected: result.isConnected))
                        case .trainee:
                            await send(.updateUserInfo(type: .trainee, isConnected: result.isConnected))
                        default:
                            try keyChainManager.delete(.sessionId)
                            await send(.updateUserInfo(type: nil, isConnected: false))
                        }
                    }
                }
                
            case .checkSessionInfo:
                let session: String? = try? keyChainManager.read(for: .sessionId)
                return session != nil
                ? .send(.api(.checkSession))
                : .send(.updateUserInfo(type: nil, isConnected: false))
                
            case let .updateUserInfo(userType, isConnected):
                state.$isConnected.withLock { $0 = isConnected }
                
                switch userType {
                case .trainee:
                    return self.setFlow(.traineeMainFlow(.init()), state: &state)
                case .trainer:
                    return self.setFlow(.trainerMainFlow(.init()), state: &state)
                default:
                    return self.setFlow(.onboardingFlow(.init()), state: &state)
                }
                
            case .splashFinished:
                state.view_isSplashActive = false
                return .none
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
        case .onboardingFlow(let flowState):
            state.userType = nil
            state.onboardingState = flowState
        case .traineeMainFlow(let flowState):
            state.userType = .trainee
            state.traineeMainState = flowState
        case .trainerMainFlow(let flowState):
            state.userType = .trainer
            state.trainerMainState = flowState
        }
        
        return .none
    }
}

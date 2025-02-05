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

@Reducer
public struct AppFlowCoordinatorFeature {
    @ObservableState
    public struct State: Equatable {
        var userType: UserType?
        
        // MARK: SubFeature state
        var trainerMainState: TrainerMainFlowFeature.State?
        var traineeMainState: TraineeMainFlowFeature.State?
        var onboardingState: OnboardingFlowFeature.State?
        
        public init(
            userType: UserType? = nil,
            onboardingState: OnboardingFlowFeature.State? = .init(),
            trainerMainState: TrainerMainFlowFeature.State? = nil,
            traineeMainState: TraineeMainFlowFeature.State? = nil
        ) {
            self.userType = userType
            self.onboardingState = onboardingState
            self.trainerMainState = trainerMainState
            self.traineeMainState = traineeMainState
        }
    }

    public enum Action {
        /// 하위 코디네이터에서 일어나는 액션을 처리합니다
        case subFeature(SubFeatureAction)
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
    }
    
    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .subFeature(let internalAction):
                switch internalAction {
                case .onboardingFlow:
                    return .none
                    
                case .trainerMainFlow:
                    return .none
                    
                case .traineeMainFlow:
                    return .none
                }
                
            case .onAppear:
                return .none
            }
        }
        .ifLet(\.onboardingState, action: \.subFeature.onboardingFlow) { OnboardingFlowFeature() }
        .ifLet(\.trainerMainState, action: \.subFeature.trainerMainFlow) { TrainerMainFlowFeature() }
        .ifLet(\.traineeMainState, action: \.subFeature.traineeMainFlow) { TraineeMainFlowFeature() }
    }
}

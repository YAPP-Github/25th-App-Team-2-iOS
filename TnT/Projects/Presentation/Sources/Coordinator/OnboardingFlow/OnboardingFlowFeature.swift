//
//  OnboardingNavigationFeature.swift
//  Presentation
//
//  Created by 박서연 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import Domain

@Reducer
public struct OnboardingFlowFeature {
    @ObservableState
    public struct State: Equatable {
        public var path: StackState<Path.State>
        @Shared var signUpEntity: PostSignUpEntity
        
        public init(
            signUpEntity: PostSignUpEntity = .init(),
            path: StackState<Path.State>? = nil
        ) {
            let shared = Shared(value: signUpEntity)
            self._signUpEntity = shared
            self.path = path ?? .init([.snsLogin(.init(signUpEntity: shared))])
        }
    }

    public enum Action: Sendable {
        /// 현재 표시되고 있는 path 화면 내부에서 일어나는 액션을 처리합니다.
        case path(StackActionOf<Path>)
        /// Flow 변경을 AppCoordinator로 전달합니다
        case switchFlow(AppFlow)
        case onAppear
    }

    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .path(action):
                switch action {
                    /// SNS 로그인 화면 로그인 완료 -> 트레이너/트레이니/회원가입
                case .element(id: _, action: .snsLogin(.setNavigating(let screen))):
                    switch screen {
                    case .traineeHome:
                        return .send(.switchFlow(.traineeMainFlow))
                    case .trainerHome:
                        return .send(.switchFlow(.trainerMainFlow))
                    case .userTypeSelection:
                        state.path.append(.userTypeSelection(.init(signUpEntity: state.$signUpEntity)))
                    }
                    
                    return .none
                
                    /// 유저 타입 선택 완료 -> 트레이니/트레이너 프로필 입력
                case .element(id: _, action: .userTypeSelection(.setNavigating(let screen))):
                    switch screen {
                    case .createProfileTrainee:
                        state.path.append(.createProfile(.init(signUpEntity: state.$signUpEntity, userType: .trainee)))
                    case .createProfileTrainer:
                        state.path.append(.createProfile(.init(signUpEntity: state.$signUpEntity, userType: .trainer)))
                    }
                    
                    return .none
                    
                    ///  약관 화면 -> 트레이너/트레이니 선택 화면 이동
                case .element(id: _, action: .createProfile(.setNavigating(let screen))):
                    switch screen {
                    case .traineeBasicInfoInput:
                        state.path.append(.traineeBasicInfoInput(.init()))
                    case .trainerSignUpComplete:
                        state.path.append(.trainerSignUpComplete(.init()))
                    }
                    
                    return .none
                    
                /// 트레이너 프로필 생성 완료 -> 다음 버튼 tapped
                case .element(id: _, action: .trainerSignUpComplete(.setNavigating)):
                    state.path.append(.trainerMakeInvitationCode(MakeInvitationCodeFeature.State()))
                    return .none
                
                /// 트레이너의 초대코드 화면 -> 건너뛰기 버튼 tapped
                case .element(id: _, action: .trainerMakeInvitationCode(.setNavigation)):
                    // 추후에 홈과 연결
                    return .none
                    
                default:
                    return .none
                }
                
            case .switchFlow:
                return .none
                
            case .onAppear:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension OnboardingFlowFeature {
    @Reducer(state: .equatable, .sendable)
    public enum Path {
        // MARK: Common
        /// SNS 로그인 뷰
        case snsLogin(LoginFeature)
        /// 트레이너/트레이니 선택 뷰
        case userTypeSelection(UserTypeSelectionFeature)
        /// 트레이너/트레이니의 이름 입력 뷰
        case createProfile(CreateProfileFeature)
        
        // MARK: Trainer
        /// 트레이너 회원 가입 완료 뷰
        /// TODO: 트레이너/트레이니 회원 가입 완료 화면으로 통합 필요
        case trainerSignUpComplete(TrainerSignUpCompleteFeature)
        /// 트레이너의 초대코드 발급 뷰
        case trainerMakeInvitationCode(MakeInvitationCodeFeature)
        /// 트레이너의 트레이니 프로필 확인 뷰
        case trainerConnectedTraineeProfile(ConnectedTraineeProfileFeature)
        
        // MARK: Trainee
        /// 트레이니 기본 정보 입력
        case traineeBasicInfoInput(TraineeBasicInfoInputFeature)
        /// 트레이니 PT 목적 입력
        case traineeTrainingPurpose(TraineeTrainingPurposeFeature)
        /// 트레이니 주의사항 입력
        case traineePrecautionInput(TraineePrecautionInputFeature)
        /// 트레이니 프로필 생성 완료
        /// TODO: 트레이너/트레이니 회원 가입 완료 화면으로 통합 필요
        case traineeProfileCompletion(TraineeProfileCompletionFeature)
        /// 트레이니 초대 코드입력
        case traineeInvitationCodeInput(TraineeInvitationCodeInputFeature)
        /// 트레이니 수업 정보 입력
        case traineeTrainingInfoInput(TraineeTrainingInfoInputFeature)
        /// 트레이니 연결 완료
        /// TODO: 트레이너/트레이니 연결 완료 화면으로 통합 필요
        case traineeConnectionComplete(TraineeConnectionCompleteFeature)
    }
}

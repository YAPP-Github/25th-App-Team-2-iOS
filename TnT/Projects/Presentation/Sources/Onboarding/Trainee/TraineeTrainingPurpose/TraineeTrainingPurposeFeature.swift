//
//  TraineeTrainingPurposeFeature.swift
//  Presentation
//
//  Created by 박민서 on 1/25/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import ComposableArchitecture

import Domain

/// 트레이니의 PT 목적 선택을 관리하는 리듀서
/// - 사용자가 다중 선택 가능한 PT 목적을 선택하고 검증하는 기능 포함
@Reducer
public struct TraineeTrainingPurposeFeature {
    
    @ObservableState
    public struct State: Equatable {
        // MARK: Data related state
        /// 현재 회원가입 정보
        @Shared var signUpEntity: PostSignUpEntity
        /// 사용자가 선택한 트레이닝 목적 목록 (다중 선택 가능)
        var selectedPurposes: Set<TrainingPurpose>
        
        // MARK: UI related state
        /// "다음" 버튼 활성화 여부 (최소 1개 이상 선택 시 활성화)
        var view_isNextButtonEnabled: Bool
        
        /// `TraineeTrainingPurposeFeature.State`의 생성자
        /// - Parameters:
        ///   - signUpEntity: 현재 회원가입 정보 @Shared
        ///   - selectedPurposes: 사용자가 선택한 트레이닝 목적 목록 (기본값: 빈 `Set`)
        ///   - view_isNextButtonEnabled: "다음" 버튼 활성화 여부 (기본값: `true`)
        public init(
            signUpEntity: Shared<PostSignUpEntity>,
            selectedPurposes: Set<TrainingPurpose> = [],
            view_isNextButtonEnabled: Bool = true
        ) {
            self._signUpEntity = signUpEntity
            self.selectedPurposes = selectedPurposes
            self.view_isNextButtonEnabled = view_isNextButtonEnabled
        }
    }
    
    public enum Action: Sendable, ViewAction {
        /// 뷰에서 발생한 액션을 처리합니다.
        case view(View)
        /// 네비게이션 여부 설정
        case setNavigating
        
        @CasePathable
        public enum View: Sendable, BindableAction {
            /// 바인딩할 액션을 처리
            case binding(BindingAction<State>)
            /// 트레이닝 목적 선택 버튼이 눌렸을 때
            case tapPurposeButton(TrainingPurpose)
            /// "다음으로" 버튼이 눌렸을 때
            case tapNextButton
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        
        Reduce { state, action in
            switch action {
            case .view(let action):
                switch action {
                case .binding:
                    return .none
                
                case .tapPurposeButton(let purpose):
                    if state.selectedPurposes.remove(purpose) == nil {
                        state.selectedPurposes.insert(purpose)
                    }
                    return self.validate(&state)
                    
                case .tapNextButton:
                    let purposes = state.selectedPurposes.map {
                        $0.koreanName
                    }
                    state.$signUpEntity.withLock { $0.goalContents = purposes }
                    return .send(.setNavigating)
                }

            case .setNavigating:
                return .none
            }
        }
    }
}

// MARK: Internal Logic
private extension TraineeTrainingPurposeFeature {
    func validate(_ state: inout State) -> Effect<Action> {
        state.view_isNextButtonEnabled = true // 항상 활성화
        return .none
    }
}

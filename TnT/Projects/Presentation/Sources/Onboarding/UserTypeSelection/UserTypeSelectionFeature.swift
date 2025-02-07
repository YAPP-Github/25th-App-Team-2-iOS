//
//  UserTypeSelectionFeature.swift
//  Presentation
//
//  Created by 박민서 on 1/17/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import ComposableArchitecture

import Domain

/// 역할 선택 화면의 상태 및 로직을 관리하는 리듀서입니다.
@Reducer
public struct UserTypeSelectionFeature {
    
    @ObservableState
    public struct State: Equatable {
        // MARK: Data related state
        /// 현재 회원가입 정보
        @Shared var signUpEntity: PostSignUpEntity
        /// 현재 선택된 유저 타입 (트레이너/트레이니)
        var userType: UserType
        
        // MARK: UI related state
        /// 다음 화면으로 이동 여부
        public var view_isNavigating: Bool
        
        /// `UserTypeSelectionFeature.State`의 생성자
        /// - Parameters:
        ///   - userType: 현재 선택된 유저 타입 (기본값: `.trainer`)
        ///   - isNavigating: 네비게이션 여부 (기본값: `false`)
        public init(
            userType: UserType = .trainer,
            view_isNavigating: Bool = false,
            signUpEntity: Shared<PostSignUpEntity>
        ) {
            self.userType = userType
            self.view_isNavigating = view_isNavigating
            self._signUpEntity = signUpEntity
        }
    }
    
    public enum Action: Sendable, ViewAction {
        /// 뷰에서 발생한 액션을 처리합니다.
        case view(ViewAction)
        /// 네비게이션 설정
        case setNavigating(RoutingScreen)
        
        public enum ViewAction: Sendable, BindableAction {
            /// 바인딩할 액션을 처리합니다
            case binding(BindingAction<State>)
            /// 유저 타입 선택 버튼이 눌렸을 때
            case tapUserTypeButton(UserType)
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
                    
                case .tapUserTypeButton(let userType):
                    state.userType = userType
                    return .none
                    
                case .tapNextButton:
                    state.$signUpEntity.withLock { $0.memberType = state.userType }
                    switch state.userType {
                    case .trainer:
                        return .send(.setNavigating(.createProfileTrainer))
                    case .trainee:
                        return .send(.setNavigating(.createProfileTrainee))
                    }
                }
                
            case .setNavigating:
                return .none
            }
        }
    }
}

extension UserTypeSelectionFeature {
    /// 하위 화면에서 파생되는 라우팅을 전달합니다
    public enum RoutingScreen: Sendable {
        /// 트레이니 회원가입
        case createProfileTrainee
        /// 트레이너 회원가입
        case createProfileTrainer
    }
}

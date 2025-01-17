//
//  CreateProfileFeature.swift
//  Presentation
//
//  Created by 박민서 on 1/17/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import ComposableArchitecture

import Domain

/// 역할 선택 화면의 상태 및 로직을 관리하는 리듀서입니다.
@Reducer
public struct CreateProfileFeature {
    
    @ObservableState
    public struct State {
        /// 현재 선택된 유저 타입 (트레이너/트레이니)
        var userType: UserType
        /// UI 관련 상태
        var viewState: ViewState
        
        /// `UserTypeSelectionFeature.State`의 생성자
        /// - Parameters:
        ///   - userType: 현재 선택된 유저 타입 (기본값: `.trainer`)
        ///   - viewState: UI 관련 상태 (기본값: `ViewState()`).
        public init(userType: UserType = .trainer, viewState: ViewState = .init()) {
            self.userType = userType
            self.viewState = viewState
        }
    }
    
    /// UI 관련 상태를 관리하는 구조체입니다.
    public struct ViewState: Equatable {
        /// 다음 화면으로 이동 여부
        public var isNavigating: Bool
        
        /// `ViewState`의 생성자
        /// - Parameter isNavigating: 네비게이션 여부 (기본값: `false`)
        public init(isNavigating: Bool = false) {
            self.isNavigating = isNavigating
        }
    }
    
    
    public enum Action: ViewAction {
        /// 네비게이션 여부 설정
        case setNavigating(Bool)
        /// 뷰에서 발생한 액션을 처리합니다.
        case view(ViewAction)
        
        public enum ViewAction {
            /// 유저 타입 선택 버튼이 눌렸을 때
            case tapUserTypeButton(UserType)
            /// "다음으로" 버튼이 눌렸을 때
            case tapNextButton
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let action):
                switch action {
                case .tapUserTypeButton(let userType):
                    state.userType = userType
                    return .none
                case .tapNextButton:
                    print("다음으로..")
                    return .send(.setNavigating(true))
                }
            case .setNavigating(let isNavigating):
                state.viewState.isNavigating = isNavigating
                return .none
            }
        }
    }
}

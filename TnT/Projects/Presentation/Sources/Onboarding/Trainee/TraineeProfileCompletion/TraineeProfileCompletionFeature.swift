//
//  TraineeProfileCompletionFeature.swift
//  Presentation
//
//  Created by 박민서 on 1/26/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation
import ComposableArchitecture

import Domain

/// 회원가입 완료 후 프로필 정보를 표시하는 리듀서
@Reducer
public struct TraineeProfileCompletionFeature {
    
    @ObservableState
    public struct State: Equatable {
        // MARK: Data related state
        /// 현재 사용자 유저 타입 (트레이너/트레이니)
        var userType: UserType
        /// 현재 사용자 이름
        var userName: String
        /// 등록한 프로필 이미지 링크
        var profileImage: String?
        
        // MARK: UI related state
        /// 상대방 유저 타입 (사용자가 트레이너면 트레이니, 트레이니면 트레이너)
        var view_opponentUserType: UserType {
            return userType == .trainer ? .trainee : .trainer
        }
        
        /// `TraineeProfileCompletionFeature.State`의 생성자
        /// - Parameters:
        ///   - userType: 현재 선택된 유저 타입 (기본값: `.trainee`)
        ///   - userName: 입력된 사용자 이름 (기본값: `""`)
        ///   - profileImage: 등록한 프로필 이미지 링크 (기본값: `nil`)
        public init(
            userType: UserType = .trainee,
            userName: String = "",
            profileImage: String? = nil
        ) {
            self.userType = userType
            self.userName = userName
            self.profileImage = profileImage
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
                    
                case .tapNextButton:
                    return .send(.setNavigating)
                }

            case .setNavigating:
                return .none
            }
        }
    }
}

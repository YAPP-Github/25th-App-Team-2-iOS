//
//  AddTraineeFeature.swift
//  Presentation
//
//  Created by 박서연 on 2/14/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import DesignSystem
import DIContainer

@Reducer
public struct AddTraineeFeature {

    @ObservableState
    public struct State: Equatable {
        var invitationCode: String = ""
        
        public init() { }
    }
    
    @Dependency(\.trainerRepoUseCase) var trainerRepoUseCase
    
    public enum Action: ViewAction {
        /// 화면 내 발생 액션 처리
        case view(View)
        /// api 콜 액션 처리
        case api(APIAction)
        /// 초대 코드 설정
        case setInvitationCode(String)
        /// 네비게이션 처리
        case setNavigation
        
        @CasePathable
        public enum View: Sendable, BindableAction {
            /// 바인딩 액션 처리
            case binding(BindingAction<State>)
            /// 코드 재발급 버튼 탭
            case tappedReissuanceButton
            /// 코드 카피 영역 탭
            case tapCodeToCopy
            /// 화면 표시될 때
            case onAppear
        }
        
        @CasePathable
        public enum APIAction: Sendable {
            /// 초대 코드 불러오기 API
            case getInvitationCode
            /// 초대 코드 재발급하기 API
            case reissueInvitationCode
        }
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        
        Reduce { state, action in
            switch action {
            case .view(let view):
                switch view {
                case .binding:
                    return .none
                    
                case .tapCodeToCopy:
                    UIPasteboard.general.string = state.invitationCode
                    NotificationCenter.default.post(toast: .init(presentType: .text("⚠"), message: "코드가 복사되었어요!"))
                    return .none
                    
                case .tappedReissuanceButton:
                    return .send(.api(.reissueInvitationCode))
                    
                case .onAppear:
                    return .send(.api(.getInvitationCode))
                }
                
            case .api(let action):
                switch action {
                case .getInvitationCode:
                    return .run { send in
                        let result = try await trainerRepoUseCase.getTheFirstInvitationCode()
                        await send(.setInvitationCode(result.invitationCode))
                    }
                    
                case .reissueInvitationCode:
                    return .run { send in
                        let result = try await trainerRepoUseCase.getReissuanceInvitationCode()
                        await send(.setInvitationCode(result.invitationCode))
                    }
                }
                
            case .setInvitationCode(let code):
                state.invitationCode = code
                return .none
                
            case .setNavigation:
                return .none
            }
        }
    }
}

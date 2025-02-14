//
//  CheckTrainerInvitationCodeFeature.swift
//  Presentation
//
//  Created by 박서연 on 2/15/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import DIContainer

@Reducer
public struct CheckTrainerInvitationCodeFeature {
    
    @ObservableState
    public struct State: Equatable {
        var invitationCode: String = ""
        
        public init() { }
    }

    @Dependency(\.trainerRepoUseCase) var trainerRepoUseCase
    
    public enum Action: Sendable, ViewAction {
        /// 초대 코드 설정
        case setInvitationCode(String)
        /// 초대 코드 재발급
        case reissueInvitationCode
        case view(View)
        
        public enum View: Sendable {
            /// 화면 나타날때
            case onAppear
            /// 코드 재발급 버튼 탭
            case tappedReissuanceButton
            /// 코드 카피 영역 탭
            case tapCodeToCopy
        }
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .setInvitationCode(let code):
                state.invitationCode = code
                return .none
                
            case .reissueInvitationCode:
                return .run { send in
                    let result = try await trainerRepoUseCase.getReissuanceInvitationCode()
                    await send(.setInvitationCode(result.invitationCode))
                }
                
            case .view(let action):
                switch action {
                case .tappedReissuanceButton:
                    return .send(.reissueInvitationCode)
                    
                case .tapCodeToCopy:
                    UIPasteboard.general.string = state.invitationCode
                    NotificationCenter.default.post(toast: .init(presentType: .text("⚠"), message: "코드가 복사되었어요!"))
                    return .none
                    
                case .onAppear:
                    return .run { send in
                        let result = try await trainerRepoUseCase.getTheFirstInvitationCode()
                        await send(.setInvitationCode(result.invitationCode))
                    }
                }
            }
        }
    }
}

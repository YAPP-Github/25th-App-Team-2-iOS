//
//  TraineeInvitationCodeInputFeature.swift
//  Presentation
//
//  Created by 박민서 on 1/26/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation
import ComposableArchitecture

import Domain
import DesignSystem
import DIContainer

@Reducer
public struct TraineeInvitationCodeInputFeature {
    
    @ObservableState
    public struct State: Equatable {
        // MARK: Data related state
        /// 입력된 초대코드
        var invitationCode: String
        
        // MARK: UI related state
        /// 텍스트 필드 상태 (빈 값 / 입력됨 / 유효하지 않음)
        var view_invitationCodeStatus: TTextField.Status
        /// 텍스트 필드 푸터 텍스트
        var view_textFieldFooterText: String
        /// 현재 텍스트필드 포커스
        var view_isFieldFocused: Bool
        /// 인증하기 버튼 활성화 상태
        var view_isVerityButtonEnabled: Bool
        /// 다음 버튼 활성화 여부
        var view_isNextButtonEnabled: Bool
        /// 팝업 표시 여부
        var view_isPopupPresented: Bool
        
        /// `TraineeInvitationCodeInputFeature.State`의 생성자
        /// - Parameters:
        public init(
            invitationCode: String = "",
            view_invitationCodeStatus: TTextField.Status = .empty,
            view_textFieldFooterText: String = "",
            view_isFieldFocused: Bool = false,
            view_isVerityButtonEnabled: Bool = false,
            view_isNextButtonEnabled: Bool = false,
            view_isPopupPresented: Bool = true
        ) {
            self.invitationCode = invitationCode
            self.view_invitationCodeStatus = view_invitationCodeStatus
            self.view_textFieldFooterText = view_textFieldFooterText
            self.view_isFieldFocused = view_isFieldFocused
            self.view_isVerityButtonEnabled = view_isVerityButtonEnabled
            self.view_isNextButtonEnabled = view_isNextButtonEnabled
            self.view_isPopupPresented = view_isPopupPresented
        }
    }
    
    @Dependency(\.traineeUseCase) private var traineeUseCase: TraineeUseCase
    
    public enum Action: Sendable, ViewAction {
        /// 뷰에서 발생한 액션을 처리합니다.
        case view(View)
        /// 네비게이션 여부 설정
        case setNavigating(RoutingScreen)
        /// 다음 버튼 활성화 상태 조작
        case updateVerificationStatus(Bool)
        
        @CasePathable
        public enum View: Sendable, BindableAction {
            /// 바인딩할 액션을 처리
            case binding(BindingAction<State>)
            /// 인증하기 버튼이 눌렸을 때
            case tapVerifyButton
            /// "다음으로" 버튼이 눌렸을 때
            case tapNextButton
            /// 포커스 상태 변경
            case setFocus(Bool)
            /// Nav바 건너뛰기 버튼이 눌렸을 때
            case tapNavBarSkipButton
            /// 팝업 "다음에 할게요" 버튼이 눌렸을 때
            case tapPopupNextButton
            /// 팝업 "확인" 버튼이 눌렸을 때
            case tapPopupConfirmButton
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        
        Reduce { state, action in
            switch action {
            case .view(let action):
                switch action {
                case .binding(\.invitationCode):
                    return self.validateInput(&state)
                    
                case .binding:
                    return .none

                case .tapVerifyButton:
                    return .run { [state] send in
                        let result: Bool = try await traineeUseCase.verifyTrainerInvitationCode(state.invitationCode)
                        await send(.updateVerificationStatus(result))
                    }
                    
                case .tapNextButton:
                    return .send(.setNavigating(.trainingInfoInput))
                
                case .setFocus(let isFocused):
                    state.view_isFieldFocused = isFocused
                    return .none
                
                case .tapNavBarSkipButton:
                    return .send(.setNavigating(.traineeHome))
                    
                case .tapPopupNextButton:
                    return .send(.setNavigating(.traineeHome))
                    
                case .tapPopupConfirmButton:
                    state.view_isPopupPresented = false
                    return .none
                }
                
            case .updateVerificationStatus(let isVerified):
                state.view_textFieldFooterText = isVerified ? "인증에 성공했습니다" : "인증에 실패했습니다"
                state.view_invitationCodeStatus = isVerified ? .valid : .invalid
                state.view_isNextButtonEnabled = isVerified
                return .none
            
            case .setNavigating:
                return .none
            }
        }
    }
}

// MARK: Internal Logic
private extension TraineeInvitationCodeInputFeature {
    /// 입력값을 검증하고 상태를 업데이트
    func validateInput(_ state: inout State) -> Effect<Action> {
        // 초대 코드가 비어있는 경우 (버튼 비활성화)
        guard !state.invitationCode.isEmpty else {
            state.view_textFieldFooterText = ""
            state.view_invitationCodeStatus = .empty
            state.view_isVerityButtonEnabled = false
            return .none
        }
        state.view_invitationCodeStatus = .filled
        
        // 초대 코드 형식이 유효한지 검사
        guard traineeUseCase.validateInvitationCode(state.invitationCode) else {
            state.view_isVerityButtonEnabled = false
            return .none
        }
        state.view_isVerityButtonEnabled = true
        
        return .none
    }
}

public extension TraineeInvitationCodeInputFeature {
    enum RoutingScreen: Sendable {
        case traineeHome
        case trainingInfoInput
    }
}

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
        /// 트레이너 이름
        var trainerName: String?
        
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
        /// 표시되는 팝업
        var view_popUp: PopUp?
        /// 팝업 표시 여부
        var view_isPopupPresented: Bool
        /// 상단 네비바 표시 상태
        var view_navigationType: NavigationType
        
        
        /// `TraineeInvitationCodeInputFeature.State`의 생성자
        /// - Parameters:
        ///   - invitationCode: 사용자가 입력한 초대 코드 (기본값: `""`)
        ///   - trainerName: 초대코드에 연결된 트레이너 이름 (기본값: `nil`)
        ///   - view_invitationCodeStatus: 텍스트 필드 상태 (`.empty`, `.valid`, `.invalid` 등)
        ///   - view_textFieldFooterText: 텍스트 필드 하단에 표시될 메시지 (기본값: `""`)
        ///   - view_isFieldFocused: 현재 텍스트 필드가 포커스를 받고 있는지 여부 (기본값: `false`)
        ///   - view_isVerityButtonEnabled: "인증하기" 버튼 활성화 여부 (기본값: `false`)
        ///   - view_isNextButtonEnabled: "다음" 버튼 활성화 여부 (기본값: `false`)
        ///   - view_popUp: 현재 표시되는 팝업 (기본값: `nil`)
        ///   - view_isPopupPresented: 팝업이 표시 중인지 여부 (기본값: `false`)
        ///   - view_navigationType: 현재 화면의 네비게이션 타입 (`.newUser`: "건너뛰기" 버튼 있음, `.existingUser`: "뒤로가기" 버튼 있음)
        public init(
            invitationCode: String = "",
            trainerName: String? = nil,
            view_invitationCodeStatus: TTextField.Status = .empty,
            view_textFieldFooterText: String = "",
            view_isFieldFocused: Bool = false,
            view_isVerityButtonEnabled: Bool = false,
            view_isNextButtonEnabled: Bool = false,
            view_popUp: PopUp? = nil,
            view_isPopupPresented: Bool = false,
            view_navigationType: NavigationType = .newUser
        ) {
            self.invitationCode = invitationCode
            self.trainerName = trainerName
            self.view_popUp = view_popUp
            self.view_invitationCodeStatus = view_invitationCodeStatus
            self.view_textFieldFooterText = view_textFieldFooterText
            self.view_isFieldFocused = view_isFieldFocused
            self.view_isVerityButtonEnabled = view_isVerityButtonEnabled
            self.view_isNextButtonEnabled = view_isNextButtonEnabled
            self.view_isPopupPresented = view_isPopupPresented
            self.view_navigationType = view_navigationType
        }
    }
    
    @Dependency(\.traineeUseCase) private var traineeUseCase: TraineeUseCase
    @Dependency(\.trainerRepoUseCase) private var trainerRepoUseCase
    
    public enum Action: Sendable, ViewAction {
        /// 뷰에서 발생한 액션을 처리합니다.
        case view(View)
        /// api 콜 액션 처리
        case api(APIAction)
        /// 네비게이션 여부 설정
        case setNavigating(RoutingScreen)
        /// 다음 버튼 활성화 상태 조작
        case updateVerificationStatus(Bool)
        /// 트레이너 이름 설정
        case setTrainerName(String)
        
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
            /// Nav바 back 버튼이 눌렸을 때
            case tapNavBarBackButton
            
            /// 팝업 좌측 secondary 버튼 탭
            case tapPopUpSecondaryButton(popUp: PopUp?)
            /// 팝업 우측 primary 버튼 탭
            case tapPopUpPrimaryButton(popUp: PopUp?)
        }
        
        @CasePathable
        public enum APIAction: Sendable {
            /// 초대 코드 인증하기 API
            case verifyInvitationCode(code: String)
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
                    return .send(.api(.verifyInvitationCode(code: state.invitationCode)))
                    
                case .tapNextButton:
                    guard let trainerName = state.trainerName else { return .none }
                    print("trainerName: \(trainerName)")
                    return .send(.setNavigating(.trainingInfoInput(trainerName: trainerName)))
                    
                case .setFocus(let isFocused):
                    state.view_isFieldFocused = isFocused
                    return .none
                    
                case .tapNavBarSkipButton, .tapNavBarBackButton:
                    // 인증 후에만 팝업 표시
                    return state.view_invitationCodeStatus == .valid
                    ? self.setPopUpStatus(&state, status: .dropAlert)
                    : .send(.setNavigating(.traineeHome))
                        
                case .tapPopUpSecondaryButton(let popUp):
                    return .send(.setNavigating(.traineeHome))
                    
                case .tapPopUpPrimaryButton(let popUp):
                    return self.setPopUpStatus(&state, status: nil)
                }
                
            case .api(let action):
                switch action {
                case .verifyInvitationCode(let code):
                    return .run { send in
                        if let result = try? await trainerRepoUseCase.getVerifyInvitationCode(code: code), let trainerName = result.trainerName {
                            await send(.updateVerificationStatus(result.isVerified))
                            await send(.setTrainerName(trainerName))
                        } else {
                            await send(.updateVerificationStatus(false))
                        }
                    }
                }
                
            case .updateVerificationStatus(let isVerified):
                state.view_textFieldFooterText = isVerified ? "인증에 성공했습니다" : "인증에 실패했습니다"
                state.view_invitationCodeStatus = isVerified ? .valid : .invalid
                state.view_isNextButtonEnabled = isVerified
                return .none
                
            case .setTrainerName(let name):
                state.trainerName = name
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
    
    /// 팝업 상태, 표시 상태를 업데이트
    /// status nil 입력인 경우 팝업 표시 해제
    func setPopUpStatus(_ state: inout State, status: PopUp?) -> Effect<Action> {
        state.view_popUp = status
        state.view_isPopupPresented = status != nil
        return .none
    }
}

public extension TraineeInvitationCodeInputFeature {
    /// 본 화면에서 라우팅(파생)되는 화면
    enum RoutingScreen: Sendable {
        case traineeHome
        case trainingInfoInput(trainerName: String)
    }
    
    /// 본 화면의 네비게이션 타입
    enum NavigationType: Equatable {
        /// 신규 유저 (우측 건너뛰기 버튼)
        case newUser
        /// 기존 유저 (좌측 뒤로가기 버튼)
        case existingUser
    }
    
    /// 본 화면에 팝업으로 표시되는 목록
    enum PopUp: Equatable, Sendable {
        /// 진입 시 초대 코드를 입력해주세요
        case invitePopUp
        /// 연결을 중단하시겠어요?
        case dropAlert
        
        var title: String {
            switch self {
            case .invitePopUp:
                return "트레이너에게 받은\n초대 코드를 입력해보세요!"
            case .dropAlert:
                return "트레이너 연결을 중단하시겠어요?"
            }
        }
        
        var message: String {
            switch self {
            case .invitePopUp:
                return "트레이너와 연결하지 않을 경우\n일부 기능이 제한될 수 있어요."
            case .dropAlert:
                return "중단 시 연결을 처음부터 다시 설정해야 해요"
            }
        }
        
        var showAlertIcon: Bool {
            switch self {
            case .invitePopUp:
                return false
            case .dropAlert:
                return true
            }
        }
        
        var secondaryButtonTitle: String {
            switch self {
            case .invitePopUp:
                return "다음에 할게요"
            case .dropAlert:
                return "중단하기"
            }
        }
        
        var primaryButtonTitle: String {
            switch self {
            case .invitePopUp:
                return "확인"
            case .dropAlert:
                return "계속 진행"
            }
        }
        
        var secondaryAction: Action.View {
            return .tapPopUpSecondaryButton(popUp: self)
        }
        
        var primaryAction: Action.View {
            return .tapPopUpPrimaryButton(popUp: self)
        }
    }
}

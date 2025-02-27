//
//  TraineeTrainingInfoInputFeature.swift
//  Presentation
//
//  Created by 박민서 on 1/27/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation
import ComposableArchitecture

import Domain
import DesignSystem

@Reducer
public struct TraineeTrainingInfoInputFeature {
    
    public typealias FocusField = TraineeTrainingInfoInputView.Field
    
    @ObservableState
    public struct State: Equatable {
        // MARK: Data related state
        /// 트레이너 이름
        var trainerName: String
        /// 입력된 시작 날짜
        var startDate: String
        /// 입력된 현재 횟수
        var currentCount: String
        /// 입력된 총 횟수
        var totalCount: String
        /// 트레이너 초대코드
        var invitationCode: String
        
        // MARK: UI related state
        /// 텍스트 필드 상태 (빈 값 / 입력됨 / 유효하지 않음)
        var view_startDateStatus: TTextField.Status
        var view_currentCountStatus: TTextField.Status
        var view_totalCountStatus: TTextField.Status
        /// 현재 포커스된 필드
        var view_focusField: FocusField?
        /// DatePicker 표시 여부
        var view_isDatePickerPresented: Bool
        /// "다음" 버튼 활성화 여부
        var view_isNextButtonEnabled: Bool
        
        /// `TraineeBasicInfoInputFeature.State`의 생성자
        public init(
            trainerName: String = "",
            startDate: String = "",
            currentCount: String = "",
            totalCount: String = "",
            invitationCode: String = "",
            view_startDateStatus: TTextField.Status = .empty,
            view_currentCountStatus: TTextField.Status = .empty,
            view_totalCountStatus: TTextField.Status = .empty,
            view_isDatePickerPresented: Bool = false,
            view_isNextButtonEnabled: Bool = false
        ) {
            self.trainerName = trainerName
            self.startDate = startDate
            self.currentCount = currentCount
            self.totalCount = totalCount
            self.invitationCode = invitationCode
            self.view_startDateStatus = view_startDateStatus
            self.view_currentCountStatus = view_currentCountStatus
            self.view_totalCountStatus = view_totalCountStatus
            self.view_isDatePickerPresented = view_isDatePickerPresented
            self.view_isNextButtonEnabled = view_isNextButtonEnabled
        }
    }
    
    @Dependency(\.traineeUseCase) private var traineeUseCase: TraineeUseCase
    @Dependency(\.traineeRepoUseCase) private var traineeRepoUseCase
    
    public enum Action: Sendable, ViewAction {
        /// 뷰에서 발생한 액션을 처리합니다.
        case view(View)
        /// api 콜 액션 처리
        case api(APIAction)
        /// 네비게이션 여부 설정
        case setNavigating(RoutingScreen)
        
        @CasePathable
        public enum View: Sendable, BindableAction {
            /// 바인딩할 액션을 처리
            case binding(BindingAction<State>)
            /// 생년월일 입력 필드가 탭되었을 때 (DatePicker 표시)
            case tapStartDateTextField
            /// DatePicker에서 날짜를 선택했을 때
            case tapStartDatePickerDoneButton(Date)
            /// "다음으로" 버튼이 눌렸을 때
            case tapNextButton
            /// 포커스 상태 변경
            case setFocus(FocusField?, FocusField?)
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
                case .binding:
                    return .none
                    
                case .tapStartDateTextField:
                    state.view_isDatePickerPresented = true
                    return .send(.view(.setFocus(state.view_focusField, .startDate)))
                    
                case .tapStartDatePickerDoneButton(let date):
                    state.view_isDatePickerPresented = false
                    state.startDate = date.toString(format: .yyyyMMddSlash)
                    state.view_startDateStatus = state.startDate.isEmpty ? .empty : .filled
                    return .send(.view(.setFocus(.startDate, nil)))
                    
                case let .setFocus(oldFocus, newFocus):
                    state.view_focusField = newFocus
                    return oldFocus != newFocus
                    ? self.validateInput(&state, field: oldFocus)
                    : .none
                    
                case .tapNextButton:
                    return .send(.api(.verifyInvitationCode(code: state.invitationCode)))
                }
                
            case .api(let action):
                switch action {
                case .verifyInvitationCode(let code):
                    guard let currentCount = Int(state.currentCount), let totalCount = Int(state.totalCount) else { return .none }
                    return .run { [state] send in
                        let result = try await traineeRepoUseCase.postConnectTrainer(
                            .init(
                                invitationCode: state.invitationCode,
                                startDate: state.startDate.replacingOccurrences(of: "/", with: "-"),
                                totalPtCount: totalCount,
                                finishedPtCount: currentCount
                            )
                        )
                        await send(
                            .setNavigating(
                                .connectionComplete(
                                    trainerName: result.trainerName,
                                    traineeName: result.traineeName,
                                    trainerImageUrl: result.trainerProfileImageUrl,
                                    traineeImageUrl: result.traineeProfileImageUrl
                                )
                            )
                        )
                    }
                }

            case .setNavigating:
                return .none
            }
        }
    }
}

// MARK: Internal Logic
private extension TraineeTrainingInfoInputFeature {
    /// 개별 필드의 입력값을 검증하고 상태를 업데이트
    func validateInput(_ state: inout State, field: FocusField?) -> Effect<Action> {
        guard let field else { return .none }
        switch field {
        case .startDate:
            guard !state.startDate.isEmpty, traineeUseCase.validateStartDate(state.startDate) else {
                state.view_startDateStatus = state.startDate.isEmpty ? .empty : .invalid
                return self.validateAllFields(&state)
            }
            state.view_startDateStatus = .filled
        case .currentCount:
            guard !state.currentCount.isEmpty, traineeUseCase.validatePtCount(state.currentCount) else {
                state.view_currentCountStatus = state.currentCount.isEmpty ? .empty : .invalid
                return self.validateAllFields(&state)
            }
            state.view_currentCountStatus = .filled
        case .totalCount:
            guard !state.totalCount.isEmpty, traineeUseCase.validatePtCount(state.totalCount) else {
                state.view_totalCountStatus = state.totalCount.isEmpty ? .empty : .invalid
                return self.validateAllFields(&state)
            }
            state.view_totalCountStatus = .filled
        }
                
        return self.validateAllFields(&state)
    }
    
    /// 모든 필드의 상태를 검증하여 "다음" 버튼 활성화 여부를 결정
    func validateAllFields(_ state: inout State) -> Effect<Action> {
        if let currentCount = Int(state.currentCount), let totalCount = Int(state.totalCount), currentCount > totalCount {
            state.view_currentCountStatus = .invalid
            state.view_totalCountStatus = .invalid
            return .none
        }
        
        let dateValid: Bool = !state.startDate.isEmpty && state.view_startDateStatus != .invalid
        let currentCountValid: Bool = !state.currentCount.isEmpty && state.view_currentCountStatus != .invalid
        let totalCountValid: Bool = !state.totalCount.isEmpty && state.view_totalCountStatus != .invalid

        state.view_isNextButtonEnabled = dateValid && currentCountValid && totalCountValid
        return .none
    }
}

extension TraineeTrainingInfoInputFeature {
    public enum RoutingScreen: Sendable {
        case connectionComplete(trainerName: String, traineeName: String, trainerImageUrl: String, traineeImageUrl: String)
    }
}

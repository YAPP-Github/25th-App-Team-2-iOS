//
//  TraineeBasicInfoInputFeature.swift
//  Presentation
//
//  Created by 박민서 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import UIKit
import ComposableArchitecture

import Domain
import DesignSystem

@Reducer
public struct TraineeBasicInfoInputFeature {
    
    public typealias FocusField = TraineeBasicInfoInputView.Field
    
    @ObservableState
    public struct State: Equatable {
        // MARK: Data related state
        /// 입력된 생년월일
        var birthDate: String
        /// 입력된 키
        var height: String
        /// 입력된 몸무게
        var weight: String
        
        // MARK: UI related state
        /// 텍스트 필드 상태 (빈 값 / 입력됨 / 유효하지 않음)
        var view_birthDateStatus: TTextField.Status
        var view_heightStatus: TTextField.Status
        var view_weightStatus: TTextField.Status
        /// 현재 포커스된 필드
        var view_focusField: FocusField?
        /// DatePicker 표시 여부
        var view_isDatePickerPresented: Bool
        /// "다음" 버튼 활성화 여부
        var view_isNextButtonEnabled: Bool
        
        /// `TraineeBasicInfoInputFeature.State`의 생성자
        /// - Parameters:
        ///   - birthDate: 입력된 생년월일 (기본값: `""`)
        ///   - height: 입력된 키 (기본값: `""`)
        ///   - weight: 입력된 몸무게 (기본값: `""`)
        ///   - view_birthDateStatus: 생년월일 필드 상태 (기본값: `.empty`)
        ///   - view_heightStatus: 키 필드 상태 (기본값: `.empty`)
        ///   - view_weightStatus: 몸무게 필드 상태 (기본값: `.empty`)
        ///   - view_isDatePickerPresented: DatePicker 표시 여부 (기본값: `false`)
        ///   - view_isNextButtonEnabled: "다음" 버튼 활성화 여부 (기본값: `false`)
        public init(
            birthDate: String = "",
            height: String = "",
            weight: String = "",
            view_birthDateStatus: TTextField.Status = .empty,
            view_heightStatus: TTextField.Status = .empty,
            view_weightStatus: TTextField.Status = .empty,
            view_isDatePickerPresented: Bool = false,
            view_isNextButtonEnabled: Bool = false
        ) {
            self.birthDate = birthDate
            self.height = height
            self.weight = weight
            self.view_birthDateStatus = view_birthDateStatus
            self.view_heightStatus = view_heightStatus
            self.view_weightStatus = view_weightStatus
            self.view_isDatePickerPresented = view_isDatePickerPresented
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
            /// 생년월일 입력 필드가 탭되었을 때 (DatePicker 표시)
            case tapBirthDateTextField
            /// DatePicker에서 날짜를 선택했을 때
            case tapBirthDatePickerDoneButton(Date)
            /// "다음으로" 버튼이 눌렸을 때
            case tapNextButton
            /// 포커스 상태 변경
            case setFocus(FocusField?, FocusField?)
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
                
                case .tapBirthDateTextField:
                    state.view_isDatePickerPresented = true
                    return .send(.view(.setFocus(state.view_focusField, .birthDate)))
                
                case .tapBirthDatePickerDoneButton(let date):
                    state.view_isDatePickerPresented = false
                    state.birthDate = date.toString(format: .yyyyMMddSlash)
                    state.view_birthDateStatus = state.birthDate.isEmpty ? .empty : .filled
                    return .none
                    
                case let .setFocus(oldFocus, newFocus):
                    state.view_focusField = newFocus
                    return newFocus == nil
                    ? self.validateInput(&state, field: oldFocus)
                    : .none
                    
                case .tapNextButton:
                    return .send(.setNavigating)
                }

            case .setNavigating:
                return .none
            }
        }
    }
}

// MARK: Internal Logic
private extension TraineeBasicInfoInputFeature {
    /// 개별 필드의 입력값을 검증하고 상태를 업데이트
    func validateInput(_ state: inout State, field: FocusField?) -> Effect<Action> {
        guard let field else { return .none }
        switch field {
        case .birthDate:
            guard !state.birthDate.isEmpty, UserPolicy.birthDateInput.textValidation(state.birthDate) else {
                state.view_birthDateStatus = state.birthDate.isEmpty ? .empty : .invalid
                return self.validateAllFields(&state)
            }
            state.view_birthDateStatus = .filled
        case .height:
            guard !state.height.isEmpty, UserPolicy.heightInput.textValidation(state.height) else {
                state.view_heightStatus = state.height.isEmpty ? .empty : .invalid
                return self.validateAllFields(&state)
            }
            state.view_heightStatus = .filled
        case .weight:
            guard !state.weight.isEmpty, UserPolicy.weightInput.textValidation(state.weight) else {
                state.view_weightStatus = state.weight.isEmpty ? .empty : .invalid
                return self.validateAllFields(&state)
            }
            state.view_weightStatus = .filled
        }
        
        return self.validateAllFields(&state)
    }
    
    /// 모든 필드의 상태를 검증하여 "다음" 버튼 활성화 여부를 결정
    func validateAllFields(_ state: inout State) -> Effect<Action> {
        let dateValid: Bool = state.birthDate.isEmpty || state.view_birthDateStatus == .filled
        let heightValid: Bool = !state.height.isEmpty && state.view_heightStatus != .invalid
        let weightValid: Bool = !state.weight.isEmpty && state.view_weightStatus != .invalid

        state.view_isNextButtonEnabled = dateValid && heightValid && weightValid
        return .none
    }
}

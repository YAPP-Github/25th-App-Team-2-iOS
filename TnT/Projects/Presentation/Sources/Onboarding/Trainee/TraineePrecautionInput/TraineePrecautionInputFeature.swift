//
//  TraineePrecautionInputFeature.swift
//  Presentation
//
//  Created by 박민서 on 1/25/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import ComposableArchitecture

import Domain
import DesignSystem

/// 트레이너에게 전달할 주의사항 입력을 관리하는 리듀서
/// - 사용자가 자유롭게 텍스트 입력 가능
/// - 입력된 내용을 검증하여 "다음" 버튼 활성화
@Reducer
public struct TraineePrecautionInputFeature {
    
    @ObservableState
    public struct State: Equatable {
        // MARK: Data related state
        /// 사용자가 입력한 주의사항
        var precaution: String
        
        // MARK: UI related state
        /// 텍스트 에디터 상태 (빈 값 / 입력됨 / 유효하지 않음)
        var view_editorStatus: TTextEditor.Status
        /// 텍스트 에디터 최대 길이 제한
        var view_editorMaxCount: Int?
        /// 텍스트 에디터 포커스 여부
        var view_focusField: Bool
        /// "다음" 버튼 활성화 여부
        var view_isNextButtonEnabled: Bool
        
        /// `TraineePrecautionInputFeature.State`의 생성자
        /// - Parameters:
        ///   - precaution: 입력된 주의사항 (기본값: `""`)
        ///   - view_editorStatus: 텍스트 에디터 상태 (기본값: `.empty`)
        ///   - view_editorMaxCount: 텍스트 에디터 최대 길이 제한 (기본값: `nil`)
        ///   - view_focusField: 텍스트 에디터 포커스 여부 (기본값: `false`)
        ///   - view_isNextButtonEnabled: "다음" 버튼 활성화 여부 (기본값: `true`)
        public init(
            precaution: String = "",
            view_editorStatus: TTextEditor.Status = .empty,
            view_editorMaxCount: Int? = nil,
            view_focusField: Bool = false,
            view_isNextButtonEnabled: Bool = true
        ) {
            self.precaution = precaution
            self.view_editorStatus = view_editorStatus
            self.view_editorMaxCount = view_editorMaxCount
            self.view_focusField = view_focusField
            self.view_isNextButtonEnabled = view_isNextButtonEnabled
        }
    }
    
    @Dependency(\.userUseCase) private var userUseCase: UserUseCase
    
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
            /// 포커스 상태 변경
            case setFocus(Bool)
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        
        Reduce { state, action in
            switch action {
            case .view(let action):
                switch action {
                case .binding(\.precaution):
                    return self.validateInput(&state)
                    
                case .binding:
                    return .none
                    
                case .setFocus(let isOn):
                    state.view_focusField = isOn
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

// MARK: Internal Logic
private extension TraineePrecautionInputFeature {
    /// 텍스트 에디터 입력값을 검증하고 상태를 업데이트
    func validateInput(_ state: inout State) -> Effect<Action> {
        guard !state.precaution.isEmpty, userUseCase.validatePrecaution(state.precaution) else {
            state.view_editorStatus = state.precaution.isEmpty ? .empty : .invalid
            state.view_isNextButtonEnabled = false
            return .none
        }
        state.view_editorStatus = .filled
        state.view_isNextButtonEnabled = true
        return .none
    }
}

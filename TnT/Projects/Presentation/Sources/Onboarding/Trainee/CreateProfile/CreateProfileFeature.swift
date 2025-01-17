//
//  CreateProfileFeature.swift
//  Presentation
//
//  Created by 박민서 on 1/17/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import UIKit
import ComposableArchitecture

import Domain
import DesignSystem
import _PhotosUI_SwiftUI

/// 역할 선택 화면의 상태 및 로직을 관리하는 리듀서입니다.
@Reducer
public struct CreateProfileFeature {
    
    @ObservableState
    public struct State {
        /// 현재 선택된 유저 타입 (트레이너/트레이니)
        var userType: UserType
        /// 현재 입력된 사용자 이름
        var userName: String
        /// 선택된 프로필 이미지 (데이터 형식)
        var userImageData: Data?
        
        /// UI 관련 상태
        var viewState: ViewState
        
        /// `CreateProfileFeature.State`의 생성자
        /// - Parameters:
        ///   - userType: 현재 선택된 유저 타입 (기본값: `.trainer`)
        ///   - userName: 입력된 유저 이름  (기본값: 공백)
        ///   - userImageData: 선택된 이미지 데이터 (기본값: `nil`)
        ///   - viewState: UI 관련 상태 (기본값: `ViewState()`).
        public init(
            userType: UserType,
            userImageData: Data? = nil,
            userName: String = "",
            viewState: ViewState = ViewState()
        ) {
            self.userType = userType
            self.userImageData = userImageData
            self.userName = userName
            self.viewState = viewState
        }
    }
    
    /// UI 관련 상태를 관리하는 구조체입니다.
    public struct ViewState: Equatable {
        /// 텍스트 필드 상태 (빈 값 / 입력됨 / 유효하지 않음)
        var textFieldStatus: TTextField.Status
        /// 포토 피커 표시 여부
        var showPhotoPicker: Bool
        /// "다음" 버튼 활성화 여부
        var isNextButtonEnabled: Bool
        /// 네비게이션 여부 (다음 화면 이동)
        var isNavigating: Bool
        /// 현재 선택된 이미지 (PhotosPickerItem)
        var photoPickerItem: PhotosPickerItem?
        
        /// 하단 푸터 텍스트 표시 여부 (이름이 유효하지 않을 경우 표시)
        var showFooterText: Bool {
            return textFieldStatus == .invalid
        }
        
        /// `ViewState`의 생성자
        /// - Parameters:
        ///   - textFieldStatus: 텍스트 필드 상태  (기본값: `.empty`)
        ///   - showPhotoPicker: 포토 피커 표시 여부  (기본값: `false`)
        ///   - isNextButtonEnabled: "다음" 버튼 활성화 여부  (기본값: `false`)
        ///   - isNavigating: 네비게이션 여부  (기본값: `false`)
        ///   - photoPickerItem: 현재 선택된 이미지 아이템 (기본값: `nil`)
        public init(
            textFieldStatus: TTextField.Status = .empty,
            showPhotoPicker: Bool = false,
            isNextButtonEnabled: Bool = false,
            isNavigating: Bool = false,
            photoPickerItem: PhotosPickerItem? = nil
        ) {
            self.textFieldStatus = textFieldStatus
            self.showPhotoPicker = showPhotoPicker
            self.isNextButtonEnabled = isNextButtonEnabled
            self.isNavigating = isNavigating
            self.photoPickerItem = photoPickerItem
        }
    }
    
    public enum Action: ViewAction {
        /// 네비게이션 여부 설정
        case setNavigating(Bool)
        /// 선택된 이미지 데이터 저장
        case imagePicked(Data?)
        /// 뷰에서 발생한 액션을 처리합니다.
        case view(ViewAction)
        
        public enum ViewAction {
            /// 프로필 사진 변경 버튼이 눌렸을 때 (사진 선택 모달 띄우기)
            case tapWriteButton
            /// 사용자 이름 입력
            case typeUserName(String)
            /// 텍스트 필드 상태 업데이트
            case updateTextFieldStatus(TTextField.Status)
            /// "다음으로" 버튼이 눌렸을 때
            case tapNextButton
            /// 포토 피커에서 이미지가 선택되었을 때
            case tapImageInPicker(PhotosPickerItem?)
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let action):
                switch action {
                case .tapWriteButton:
                    state.viewState.showPhotoPicker = true
                    return .none
                    
                case .typeUserName(let userName):
                    state.userName = userName
                    return self.validate(&state)
                    
                case .updateTextFieldStatus(let status):
                    state.viewState.textFieldStatus = status
                    return .none
                    
                case .tapNextButton:
                    print("다음으로..")
                    return .send(.setNavigating(true))
                    
                case .tapImageInPicker(let item):
                    state.viewState.photoPickerItem = item
                    return .run { [item] send in
                        if let item, let data = try? await item.loadTransferable(type: Data.self) {
                            await send(.imagePicked(data))
                        }
                    }
                }
                
            case .setNavigating(let isNavigating):
                state.viewState.isNavigating = isNavigating
                return .none
                
            case .imagePicked(let imgData):
                state.userImageData = imgData
                return .none
            }
        }
    }
}

// MARK: Internal Logic
private extension CreateProfileFeature {
    /// 사용자 입력값을 검증하고 상태를 업데이트합니다.
    private func validate(_ state: inout State) -> Effect<Action> {
        guard !(state.userName.isEmpty) else {
            state.viewState.textFieldStatus = .empty
            return .none
        }
        
        let isNameValid: Bool = TextValidator.isValidInput(
            state.userName,
            maxLength: UserPolicy.maxNameLength,
            regexPattern: UserPolicy.allowedCharactersRegex
        )
        
        state.viewState.textFieldStatus = isNameValid ? .filled : .invalid
        state.viewState.isNextButtonEnabled = isNameValid
        
        return .none
    }
}

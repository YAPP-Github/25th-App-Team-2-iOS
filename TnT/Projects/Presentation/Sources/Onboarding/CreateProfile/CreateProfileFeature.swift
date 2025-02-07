//
//  CreateProfileFeature.swift
//  Presentation
//
//  Created by 박민서 on 1/17/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import UIKit
import _PhotosUI_SwiftUI
import ComposableArchitecture

import Domain
import DesignSystem

/// 역할 선택 화면의 상태 및 로직을 관리하는 리듀서입니다.
@Reducer
public struct CreateProfileFeature {
    
    @ObservableState
    public struct State: Equatable {
        // MARK: Data related state
        /// 현재 회원가입 정보
        @Shared var signUpEntity: PostSignUpEntity
        /// 현재 선택된 유저 타입 (트레이너/트레이니)
        var userType: UserType
        /// 현재 입력된 사용자 이름
        var userName: String
        /// 선택된 프로필 이미지 (데이터 형식)
        var userImageData: Data?
        
        // MARK: UI related state
        /// 텍스트 필드 상태 (빈 값 / 입력됨 / 유효하지 않음)
        var view_textFieldStatus: TTextField.Status
        /// 텍스트 필드 최대 길이 제한
        var view_textFieldMaxCount: Int?
        /// 포토 피커 표시 여부
        var view_isPhotoPickerPresented: Bool
        /// "다음" 버튼 활성화 여부
        var view_isNextButtonEnabled: Bool
        /// 네비게이션 여부 (다음 화면 이동)
        var view_isNavigating: Bool
        /// 현재 선택된 이미지 (PhotosPickerItem)
        var view_photoPickerItem: PhotosPickerItem?
        /// 하단 푸터 텍스트 표시 여부 (이름이 유효하지 않을 경우 표시)
        var view_isFooterTextVisible: Bool {
            return view_textFieldStatus == .invalid
        }
        /// 유저의 최대 이름 길이
        var view_nameMaxLength: Int?
        
        /// `CreateProfileFeature.State`의 생성자
        /// - Parameters:
        ///   - signUpEntity: 현재 회원가입 정보 @Shared
        ///   - userType: 현재 선택된 유저 타입 (기본값: `.trainer`)
        ///   - userName: 입력된 유저 이름  (기본값: 공백)
        ///   - userImageData: 선택된 이미지 데이터 (기본값: `nil`)
        ///   - viewState: UI 관련 상태 (기본값: `ViewState()`).
        ///   - view_textFieldStatus: 텍스트 필드 상태  (기본값: `.empty`)
        ///   - view_textFieldMaxCount: 텍스트 필드 최대 길이 제한 (기본값: `nil`)
        ///   - view_isPhotoPickerPresented: 포토 피커 표시 여부  (기본값: `false`)
        ///   - view_isNextButtonEnabled: "다음" 버튼 활성화 여부  (기본값: `false`)
        ///   - view_isNavigating: 네비게이션 여부  (기본값: `false`)
        ///   - view_photoPickerItem: 현재 선택된 이미지 아이템 (기본값: `nil`)
        ///   - view_nameMaxLength:유저의 최대 이름 길이 (기본값: `nil`)
        public init(
            signUpEntity: Shared<PostSignUpEntity>,
            userType: UserType,
            userImageData: Data? = nil,
            userName: String = "",
            view_textFieldStatus: TTextField.Status = .empty,
            view_textFieldMaxCount: Int? = nil,
            view_isPhotoPickerPresented: Bool = false,
            view_isNextButtonEnabled: Bool = false,
            view_isNavigating: Bool = false,
            view_photoPickerItem: PhotosPickerItem? = nil,
            view_nameMaxLength: Int? = nil
        ) {
            self._signUpEntity = signUpEntity
            self.userType = userType
            self.userImageData = userImageData
            self.userName = userName
            self.view_textFieldStatus = view_textFieldStatus
            self.view_textFieldMaxCount = view_textFieldMaxCount
            self.view_isPhotoPickerPresented = view_isPhotoPickerPresented
            self.view_isNextButtonEnabled = view_isNextButtonEnabled
            self.view_isNavigating = view_isNavigating
            self.view_photoPickerItem = view_photoPickerItem
            self.view_nameMaxLength = view_nameMaxLength
        }
    }
    
    @Dependency(\.userUseCase) private var userUseCase: UserUseCase
    @Dependency(\.userUseRepoCase) private var userUseRepoCase: UserRepository
    
    public enum Action: Sendable, ViewAction {
        /// 네비게이션 여부 설정
        case setNavigating(RoutingScreen)
        /// 선택된 이미지 데이터 저장
        case imagePicked(Data?)
        /// 뷰에서 발생한 액션을 처리합니다.
        case view(View)
        /// 회원가입 POST
        case postSignUp
        
        @CasePathable
        public enum View: Sendable, BindableAction {
            /// 바인딩할 액션을 처리합니다
            case binding(BindingAction<State>)
            /// 프로필 사진 변경 버튼이 눌렸을 때 (사진 선택 모달 띄우기)
            case tapWriteButton
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
                case .binding(\.userName):
                    return self.validate(&state)
                    
                case .binding(\.view_photoPickerItem):
                    let item: PhotosPickerItem? = state.view_photoPickerItem
                    return .run { [item] send in
                        if let item, let data = try? await item.loadTransferable(type: Data.self) {
                            await send(.imagePicked(data))
                        }
                    }
                    
                case .binding:
                    return .none
                    
                case .tapWriteButton:
                    state.view_isPhotoPickerPresented = true
                    return .none
                    
                case .tapNextButton:
                    state.$signUpEntity.withLock { $0.name = state.userName }
                    state.$signUpEntity.withLock { $0.imageData = state.userImageData }
                    switch state.userType {
                    case .trainee:
                        return .send(.setNavigating(.traineeBasicInfoInput))
                    case .trainer:
                        return .send(.postSignUp)
                    }
                }
                
            case .postSignUp:
                guard let reqDTO = state.signUpEntity.toDTO() else {
                    return .none
                }
                let imgData = state.signUpEntity.imageData
                
                return .run { send in
                    let result = try await userUseRepoCase.postSignUp(reqDTO, profileImage: imgData).toEntity()
                    // TODO: 세션, 유저타입 정보 키체인 저장
                    await send(.setNavigating(.trainerSignUpComplete(result)))
                }
                
            case .setNavigating:
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
    func validate(_ state: inout State) -> Effect<Action> {
        guard !state.userName.isEmpty, userUseCase.validateUserName(state.userName) else {
            state.view_textFieldStatus = state.userName.isEmpty ? .empty : .invalid
            state.view_isNextButtonEnabled = false
            return .none
        }
        
        state.view_textFieldStatus = .filled
        state.view_isNextButtonEnabled = true
        return .none
    }
}

extension CreateProfileFeature {
    /// 본 화면에서 라우팅(파생)되는 화면
    public enum RoutingScreen: Sendable {
        /// 트레이니 회원가입
        case traineeBasicInfoInput
        /// 트레이너 프로필 생성 완료
        case trainerSignUpComplete(PostSignUpResEntity)
    }
}

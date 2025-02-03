//
//  TraineeMyPageFeature.swift
//  Presentation
//
//  Created by 박민서 on 2/3/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation
import ComposableArchitecture

import Domain
import DesignSystem

@Reducer
public struct TraineeMyPageFeature {
    
    public typealias FocusField = TraineeBasicInfoInputView.Field
    
    @ObservableState
    public struct State: Equatable {
        // MARK: Data related state
        /// 사용자 이름
        var userName: String
        /// 사용자 이미지 URL
        var userImageUrl: String?
        /// 앱 푸시 알림 허용 여부
        var appPushNotificationAllowed: Bool
        /// 버전 정보
        var versionInfo: String
        /// 트레이너 연결 여부
        var isTrainerConnected: Bool
        
        // MARK: UI related state
        
        public init(
            userName: String,
            userImageUrl: String? = nil,
            appPushNotificationAllowed: Bool,
            versionInfo: String,
            isTrainerConnected: Bool
        ) {
            self.userName = userName
            self.userImageUrl = userImageUrl
            self.appPushNotificationAllowed = appPushNotificationAllowed
            self.versionInfo = versionInfo
            self.isTrainerConnected = isTrainerConnected
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
            /// 개인정보 수정 버튼 탭
            case tapEditProfileButton
            /// 트레이너와 연결하기 버튼 탭
            case tapConnectTrainerButton
            /// 서비스 이용약관 버튼 탭
            case tapTOSButton
            /// 개인정보 처리방침 버튼 탭
            case tapPrivacyPolicyButton
            /// 오픈소스 라이선스 버튼 탭
            case tapOpenSourceLicenseButton
            /// 트레이너와 연결끊기 버튼 탭
            case tapDisconnectTrainerButton
            /// 로그아웃 버튼 탭
            case tapLogoutButton
            /// 계정 탈퇴 버튼 탭
            case tapWithdrawButton
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        
        Reduce { state, action in
            switch action {
            case .view(let action):
                switch action {
                case .binding(\.appPushNotificationAllowed):
                    print("푸쉬알림 변경: \(state.appPushNotificationAllowed)")
                    return .none
                case .binding:
                    return .none
                case .tapEditProfileButton:
                    print("tapEditProfileButton")
                    return .none
                    
                case .tapConnectTrainerButton:
                    print("tapConnectTrainerButton")
                    return .none
                    
                case .tapTOSButton:
                    print("tapTOSButton")
                    return .none
                    
                case .tapPrivacyPolicyButton:
                    print("tapPrivacyPolicyButton")
                    return .none
                    
                case .tapOpenSourceLicenseButton:
                    print("tapOpenSourceLicenseButton")
                    return .none
                    
                case .tapDisconnectTrainerButton:
                    print("tapDisconnectTrainerButton")
                    return .none
                    
                case .tapLogoutButton:
                    print("tapLogoutButton")
                    return .none
                    
                case .tapWithdrawButton:
                    print("tapWithdrawButton")
                    return .none
                }

            case .setNavigating:
                return .none
            }
        }
    }
}

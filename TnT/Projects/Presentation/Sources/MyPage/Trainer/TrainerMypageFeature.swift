//
//  TrainerMypageFeature.swift
//  Presentation
//
//  Created by 박서연 on 2/4/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import ComposableArchitecture

import Domain

@Reducer
public struct TrainerMypageFeature {
    
    @ObservableState
    public struct State: Equatable {
        /// 사용자 이름
        var userName: String
        /// 사용자 이미지 URL
        var userImageUrl: String?
        /// 관리 중인 회원
        var studentCount: Int
        /// 함께 했던 회원
        var oldStudentCount: Int
        /// 앱 푸시 알림 허용 여부
        var appPushNotificationAllowed: Bool
        /// 버전 정보
        var versionInfo: String
        
        public init(
            userName: String,
            userImageUrl: String? = nil,
            studentCount: Int,
            oldStudentCount: Int,
            appPushNotificationAllowed: Bool,
            versionInfo: String
        ) {
            self.userName = userName
            self.userImageUrl = userImageUrl
            self.studentCount = studentCount
            self.oldStudentCount = oldStudentCount
            self.appPushNotificationAllowed = appPushNotificationAllowed
            self.versionInfo = versionInfo
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
            /// 바인딩할 액션을 처리 (알람)
            case binding(BindingAction<State>)
            /// 서비스 이용약관 버튼 탭
            case tapTOSButton
            /// 개인정보 처리방침 버튼 탭
            case tapPrivacyPolicyButton
            /// 오픈소스 라이선스 버튼 탭
            case tapOpenSourceLicenseButton
            /// 로그아웃 버튼 탭
            case tapLogoutButton
            /// 계정 탈퇴 버튼 탭
            case tapWithdrawButton
        }
    }
    
    public init() { }
    
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
                                        
                case .tapTOSButton:
                    print("tapTOSButton")
                    return .none
                    
                case .tapPrivacyPolicyButton:
                    print("tapPrivacyPolicyButton")
                    return .none
                    
                case .tapOpenSourceLicenseButton:
                    print("tapOpenSourceLicenseButton")
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

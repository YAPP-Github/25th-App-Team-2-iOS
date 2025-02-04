//
//  TrainerMypageFeature.swift
//  Presentation
//
//  Created by 박서연 on 2/4/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import Domain
import DesignSystem

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
        /// 팝업
        var view_popUp: PopUp?
        /// 팝업 표시 유무
        var view_isPopUpPresented: Bool = false
        
        public init(
            userName: String,
            userImageUrl: String? = nil,
            studentCount: Int,
            oldStudentCount: Int,
            appPushNotificationAllowed: Bool,
            versionInfo: String,
            view_popUp: PopUp? = nil,
            view_isPopUpPresented: Bool = false
        ) {
            self.userName = userName
            self.userImageUrl = userImageUrl
            self.studentCount = studentCount
            self.oldStudentCount = oldStudentCount
            self.appPushNotificationAllowed = appPushNotificationAllowed
            self.versionInfo = versionInfo
            self.view_popUp = view_popUp
            self.view_isPopUpPresented = view_isPopUpPresented
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
            /// 팝업 왼쪽 탭
            case tapPupUpSecondaryButton(popUp: PopUp?)
            /// 팝옵 오른쪽 탭
            case tapPopUpPrimaryButton(popUp: PopUp?)
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
                    state.view_isPopUpPresented = true
                    state.view_popUp = .logout
                    return .none
                    
                case .tapWithdrawButton:
                    state.view_isPopUpPresented = true
                    state.view_popUp = .withdraw
                    print("tapWithdrawButton")
                    return .none
                    
                case .tapPupUpSecondaryButton(let popUp):
                    guard let popUp = popUp else { return .none }
                    switch popUp {
                    case .logout, .withdraw, .logoutCompleted, .withdrawCompleted:
                        state.view_popUp = nil
                        state.view_isPopUpPresented = false
                    }
                    return .none
                    
                case .tapPopUpPrimaryButton(let popUp):
                    guard let popUp = popUp else { return .none }
                    switch popUp {
                    case .logout:
                        state.view_isPopUpPresented = false
                        state.view_popUp = .logoutCompleted
                        state.view_isPopUpPresented = true
                    
                    case .logoutCompleted:
                        state.view_isPopUpPresented = false
                    
                    case .withdraw:
                        state.view_isPopUpPresented = false
                        state.view_popUp = .withdrawCompleted
                        state.view_isPopUpPresented = true
                        
                    case .withdrawCompleted:
                        state.view_isPopUpPresented = false
                    }
                    return .none
                }

            case .setNavigating:
                return .none
            }
        }
    }
}

public extension TrainerMypageFeature {
    /// 트레이너 마이페이지 팝업
    enum PopUp: Equatable, Sendable {
        /// 로그아웃
        case logout
        /// 로그아웃 완료
        case logoutCompleted
        /// 회원 탈퇴
        case withdraw
        /// 회원 탈퇴 완료
        case withdrawCompleted
        
        var nextPopUp: PopUp? {
            switch self {
            case .logout:
                return .logoutCompleted
            case .withdraw:
                return .withdrawCompleted
            case .logoutCompleted, .withdrawCompleted:
                return nil
            }
        }
        
        var title: String {
            switch self {
            case .logout:
                return "현재 계정을 로그아웃 할까요?"
            case .logoutCompleted:
                return "로그아웃이 완료되었어요"
            case .withdraw:
                return "계정을 탈퇴할까요?"
            case .withdrawCompleted:
                return "계정 탈퇴가 완료되었어요"
            }
        }
        
        var message: String {
            switch self {
            case .logout:
                return "언제든지 다시 로그인 할 수 있어요!"
            case .logoutCompleted:
                return "언제든지 다시 로그인 할 수 있어요!"
            case .withdraw:
                return "함께 했던 회원들에 대한 데이터가 사라져요!"
            case .withdrawCompleted:
                return "다음에 더 폭발적인 케미로 다시 만나요! 💣"
            }
        }
        
        var alertIcon: Bool {
            switch self {
            case .logout, .withdraw:
                return true
                
            case .logoutCompleted, .withdrawCompleted:
                return false
            }
        }
        
        var secondaryAction: Action.View? {
            switch self {
            case .logout, .withdraw:
                return .tapPupUpSecondaryButton(popUp: self)
            case .logoutCompleted, .withdrawCompleted:
                return nil
            }
        }
        
        var primaryAction: Action.View {
            return .tapPopUpPrimaryButton(popUp: self)
        }
    }
}

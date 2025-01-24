//
//  LoginFeature.swift
//  Presentation
//
//  Created by 박서연 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct LoginFeature {
    @ObservableState
    public struct State: Equatable {
        var path = StackState<Path.State>()
    }
    
    public enum Action: ViewAction {
        case view(View)
        case move(moveAction)
        case path(StackActionOf<Path>)
        
        @CasePathable
        public enum View: Equatable {
            case tappedAppleLogin
            case tappedKakaoLogin
        }
        
        @CasePathable
        public enum moveAction: Equatable {
            case toTermview // 약관동의화면으로 이동
            case toselectRole // 역할 선택화면으로 이동
            
            /// 트레이너
            case toRegisterNickname
            case toFinishedSignup
            case toMakeInvitationCode
            
            /// 트레이니
            case toRegisterUserInfo
            case toRegisterPtPurpose
            case toRegisterprecautions
            case toRegisterInvitationCode
            case toRegisterPtClassInfo
        }
        
        public enum ScopeAction {
            case term
            case selectRole
            
            /// 트레이너
            case registerNickname
            case finishedSignup
            case makeInvitationCode
            
            /// 트레이니
            case registerUserInfo
            case registerPtPurpose
            case registerprecautions
            case registerInvitationCode
            case registerPtClassInfo
        }
    }
    
    public init() {}
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(view):
                switch view {
                case .tappedAppleLogin:
                    return .none
                case .tappedKakaoLogin:
                    return .none
                }
            case let .move(move):
                switch move {
                case .toTermview:
                    state.path.append(.term)
                    return .none
                case .toselectRole:
                    state.path.append(.selectRole)
                    return .none
                case .toRegisterNickname:
                    state.path.append(.registerNickname)
                    return .none
                case .toFinishedSignup:
                    state.path.append(.finishedSignup)
                    return .none
                case .toMakeInvitationCode:
                    state.path.append(.makeInvitationCode)
                    return .none
                default:
                    return .none
                }
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
    
    @Reducer(state: .equatable)
    public enum Path {
        // 공통
        case term // 약관동의
        case selectRole // 트레이너*트레이니 선택
        
        /// 트레이너
        case registerNickname // 이름 입력
        case finishedSignup // 회원가입 완료
        case makeInvitationCode // 초대코드 발급
        
        /// 트레이니
        case registerUserInfo // 트레이니 기본 정보 입력
        case registerPtPurpose // 트레이니 PT 목적 입력
        case registerPrecautions // 트레이니 주의사항 입력
        case registerInvitationCode // 트레이니 코드입력
        case registerPtClassInfo // 트레이니 수업 정보 입력
    }
}

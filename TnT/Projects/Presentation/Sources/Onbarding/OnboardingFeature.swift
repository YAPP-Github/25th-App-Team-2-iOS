//
//  OnboardingFeature.swift
//  Presentation
//
//  Created by 박서연 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct OnboardingFeature {
    @ObservableState
    public struct State: Equatable {
        var path = StackState<Path.State>()
    }
    
    public enum Action: ViewAction {
        case view(View)
        case move(MoveAction)
        case path(StackActionOf<Path>)
        
        @CasePathable
        public enum View: Equatable {
            case tappedAppleLogin
            case tappedKakaoLogin
        }
        
        @CasePathable
        public enum MoveAction: Equatable {
            case toTermview // 약관 동의 화면으로 이동
            case toselectRole // 역할 선택화면으로 이동
            
            /// 트레이너
            case toRegisterNickname
            case toCompleteSignup
            case toMakeInvitationCode
            
            /// 트레이니
            case toRegisterUserInfo
            case toRegisterPtPurpose
            case toRegisterprecautions
            case toRegisterInvitationCode
            case toRegisterPtClassInfo
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
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
                case .toCompleteSignup:
                    state.path.append(.completeSignup(TrainerSignUpCompleteFeature.State()))
                    return .none
                case .toMakeInvitationCode:
                    state.path.append(.makeInvitationCode(MakeInvitationCodeFeature.State()))
                    return .none
                default:
                    return .none
                }
                
            case let .path(action):
                switch action {
                case .element(id: _, action: .makeInvitationCode(.tappedNextButton)):
                    state.path.append(.makeInvitationCode(MakeInvitationCodeFeature.State()))
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
        case completeSignup(TrainerSignUpCompleteFeature) // 회원가입 완료
        case makeInvitationCode(MakeInvitationCodeFeature) // 초대코드 발급
        
        /// 트레이니
        case registerUserInfo // 트레이니 기본 정보 입력
        case registerPtPurpose // 트레이니 PT 목적 입력
        case registerPrecautions // 트레이니 주의사항 입력
        case registerInvitationCode // 트레이니 코드입력
        case registerPtClassInfo // 트레이니 수업 정보 입력
    }
}

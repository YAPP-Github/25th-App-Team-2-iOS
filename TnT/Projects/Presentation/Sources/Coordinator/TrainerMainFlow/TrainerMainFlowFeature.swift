//
//  TrainerMainFlowFeature.swift
//  Presentation
//
//  Created by 박민서 on 2/5/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import Domain

@Reducer
public struct TrainerMainFlowFeature {
    @ObservableState
    public struct State: Equatable {
        public var path: StackState<Path.State>
        
        public init(path: StackState<Path.State> = .init([.mainTab(.home(.init()))])) {
            self.path = path
        }
    }

    public enum Action: Sendable {
        /// 현재 표시되고 있는 path 화면 내부에서 일어나는 액션을 처리합니다.
        case path(StackActionOf<Path>)
        /// Flow 변경을 AppCoordinator로 전달합니다
        case switchFlow(AppFlow)
        case onAppear
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .path(action):
                switch action {
                    /// 트레이니 탭뷰의 네비 관련 액션 처리
                case .element(_, action: .mainTab(.setNavigating(let screen))):
                    switch screen {
                        /// 트레이너 홈
                    case .trainerHome(let screen):
                        switch screen {
                        case .alarmPage:
                            state.path.append(.alarmCheck(.init(userType: .trainer)))
                            return .none
                        case .addPTSessionPage:
                            state.path.append(.addPTSession(.init()))
                            return .none
                        case .trainerMakeInvitationCodePage:
                            state.path.append(.trainerMakeInvitationCodePage(.init()))
                            return .none
                        }
                        
                        /// 트레이너 회원목록
                    case .trainerTraineeList:
                        return .none
                        
                        /// 트레이너 마이페이지
                    case .trainerMyPage(let screen):
                        switch screen {
                        case .onboardingLogin:
                            return .send(.switchFlow(.onboardingFlow))
                        }
                    }
                    
                default:
                    return .none
                }
                
            case .switchFlow:
                return .none
                
            case .onAppear:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        
    }
}

extension TrainerMainFlowFeature {
    @Reducer(state: .equatable, .sendable)
    public enum Path {
        // MARK: MainTab
        /// 트레이니 메인탭 - 홈/마이페이지
        case mainTab(TrainerMainTabFeature)
        
        // MARK: Home
        /// 알림 목록
        case alarmCheck(AlarmCheckFeature)
        /// PT 일정 추가
        case addPTSession(TrainerAddPTSessionFeature)
        
        // MARK: MyPage
        /// 초대코드 발급
        case trainerMakeInvitationCodePage(MakeInvitationCodeFeature)
    }
}

//
//  TrainerManagmentFeature.swift
//  Presentation
//
//  Created by 박서연 on 2/9/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import ComposableArchitecture

import Domain

@Reducer
struct  TrainerManagementFeature {
    @ObservableState
    struct State {
        var memberList: GetMembersListEntity
    }
    
    @Dependency(\.trainerRepoUseCase) private var trainerRepoUseCase: TrainerRepository
    
    public enum Action: Sendable, ViewAction {
        /// 뷰에서 발생한 에러를 처리합니다.
        case view(View)
        /// 네비게이션 여부 설정
        case setNavigating
        
        @CasePathable
        public enum View: Sendable {
            case getMembersList
        }
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .setNavigating:
                return .none
            case .view(.getMembersList):
                return .none
            }
        }
    }
}


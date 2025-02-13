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
public struct  TrainerManagementFeature {
    @ObservableState
    public struct State: Equatable {
        var traineeList: [ActiveTraineeInfoResEntity]?
    }
    
    @Dependency(\.trainerRepoUseCase) private var trainerRepoUseCase: TrainerRepository
    
    public enum Action: Sendable, ViewAction {
        /// 뷰에서 발생한 에러를 처리합니다.
        case view(View)
        /// 네비게이션 여부 설정
        case setNavigating
        
        @CasePathable
        public enum View: Sendable {
            /// 관리중인 회원목록 가져오기
            case getTraineeList
            /// 회원목록 적용
            case setTraineeList([ActiveTraineeInfoResEntity])
            /// 화면 진입시
            case onappear
            /// 회원 초대하기로 이동
            case goTraineeInvitation
        }
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onappear):
                return .run { send in
                    await send(.view(.getTraineeList))
                }
                
            case .setNavigating:
                return .none
            case .view(.getTraineeList):
                return .run { send in
                    let result: GetActiveTraineesListResDTO = try await trainerRepoUseCase.getMembersList()
                    let trainee: [ActiveTraineeInfoResEntity] = result.trainees.map { $0.dtoToEntity() }
                    await send(.view(.setTraineeList(trainee)))
                    
                }
            case .view(.setTraineeList(let trainees)):
                state.traineeList = trainees
                return .none
                
            case .view(.goTraineeInvitation):
                print("트레이너 내 회원 > 회원 초대하기로 이동")
                return .none
            }
        }
    }
}

extension TrainerManagementFeature {
    public enum RoutingScreen: Sendable {
        /// 회원추가
        case addTrainee
    }
}

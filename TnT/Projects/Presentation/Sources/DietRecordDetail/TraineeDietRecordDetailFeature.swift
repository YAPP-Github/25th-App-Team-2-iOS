//
//  TraineeDietRecordDetailFeature.swift
//  Presentation
//
//  Created by 박민서 on 2/12/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation
import ComposableArchitecture

import Domain

@Reducer
public struct TraineeDietRecordDetailFeature {
    
    @ObservableState
    public struct State: Equatable {
        // MARK: Data related state
        /// 식단 ID
        var dietId: Int
        /// 식단 사진 URL
        var dietImageURL: URL?
        /// 식단 유형
        var dietType: DietType?
        /// 식단 날짜
        var dietDate: Date?
        /// 식단 메모
        var dietInfo: String
        
        public init(
            dietId: Int,
            dietImageURL: URL? = nil,
            dietType: DietType? = nil,
            dietDate: Date? = nil,
            dietInfo: String = ""
        ) {
            self.dietId = dietId
            self.dietImageURL = dietImageURL
            self.dietType = dietType
            self.dietDate = dietDate
            self.dietInfo = dietInfo
        }
    }
    
    @Dependency(\.traineeRepoUseCase) private var traineeRepoUseCase
    
    public enum Action: Sendable, ViewAction {
        /// 뷰에서 발생한 액션을 처리합니다.
        case view(View)
        /// api 콜 액션을 처리합니다
        case api(APIAction)
        /// 식단 정보 반영
        case setDietRecordDetail(RecordListItemEntity)
        /// 네비게이션 여부 설정
        case setNavigating
        
        @CasePathable
        public enum View: Sendable, BindableAction {
            /// 바인딩할 액션을 처리
            case binding(BindingAction<State>)
            /// 우측 상단 ellipsis 버튼 탭
            case tapEllipsisButton
            /// 화면에 표시될 때
            case onAppear
        }
        
        @CasePathable
        public enum APIAction: Sendable {
            /// 식단 정보 가져오기 APi
            case getDietRecordDetail
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        
        Reduce { state, action in
            switch action {
                
            case .view(let action):
                switch action {
                case .binding:
                    return .none
                    
                case .tapEllipsisButton:
                    return .none
                    
                case .onAppear:
                    return .send(.api(.getDietRecordDetail))
                }
                
            case .api(let action):
                switch action {
                case .getDietRecordDetail:
                    let id = state.dietId
                    return .run { send in
                        let result = try await traineeRepoUseCase.getDietRecordDetail(dietId: id).toEntity()
                        await send(.setDietRecordDetail(result))
                    }
                }
                
            case .setDietRecordDetail(let info):
                state.dietImageURL = URL(string: info.imageUrl ?? "")
                state.dietType = .init(from: info.type ?? RecordType.diet(type: .breakfast))
                state.dietDate = info.date
                state.dietInfo = info.title
                return .none
                
            case .setNavigating:
                return .none
            }
        }
    }
}

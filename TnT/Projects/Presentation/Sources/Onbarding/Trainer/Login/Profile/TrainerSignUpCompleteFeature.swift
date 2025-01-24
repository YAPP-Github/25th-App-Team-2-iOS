//
//  TrainerProfileCompleteFeature.swift
//  Presentation
//
//  Created by 박서연 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

@Reducer
public struct TrainerSignUpCompleteFeature {
    @ObservableState
    public struct State: Equatable {
        var buttonTapped: Bool = false
        
        public init() { }
    }
    
    public struct ViewState: Equatable {
        public var isNavigating: Bool
        
        public init(isNavigating: Bool = false) {
            self.isNavigating = isNavigating
        }
    }
    
    public enum Action: Equatable {
        case setNavigating(Bool)
        case view(ViewAction)
        
        public enum ViewAction {
            case startButtonTapped
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let action):
                switch action {
                case .startButtonTapped:
                    print("다음으로")
                    return .send(.setNavigating(true))
                }
                
            case .setNavigating(let isNavigating):
//                state.viewState.isNavigating = isNavigating
                return .none
            }
        }
    }
}

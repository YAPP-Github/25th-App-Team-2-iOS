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
    
    public enum Action: Equatable, ViewAction {
        case setNavigating
        case view(View)
        
        public enum View {
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
                    return .send(.setNavigating)
                }
                
            case .setNavigating:
                return .none
            }
        }
    }
}

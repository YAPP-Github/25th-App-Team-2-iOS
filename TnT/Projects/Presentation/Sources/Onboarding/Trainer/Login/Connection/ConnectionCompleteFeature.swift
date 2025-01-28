//
//  ConnectionCompleteFeature.swift
//  Presentation
//
//  Created by 박서연 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct ConnectionCompleteFeature {
    @ObservableState
    public struct State: Equatable {
        var view_trainer: Data?
        var view_trainee: Data?
        
        public init() { }
    }
    
    public enum Action: Sendable, ViewAction {
        case setNavigating
        case view(View)
        
        @CasePathable
        public enum View: Sendable {
            case tappedNextButton
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let action):
                switch action {
                case .tappedNextButton:
                    return .send(.setNavigating)
                }
                
            case .setNavigating:
                return .none
            }
        }
    }
}

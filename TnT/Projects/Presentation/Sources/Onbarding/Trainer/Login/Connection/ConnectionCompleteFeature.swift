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
        var trainer: Data?
        var trainee: Data?
        
        public init() { }
    }
    
    public enum Action: Equatable {
        case setNavigating
        case view(ViewAction)
        
        public enum ViewAction {
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

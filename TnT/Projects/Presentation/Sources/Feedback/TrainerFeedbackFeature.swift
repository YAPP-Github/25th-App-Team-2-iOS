//
//  TrainerFeedbackFeature.swift
//  Presentation
//
//  Created by 박서연 on 2/15/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct TrainerFeedbackFeature {
    @ObservableState
    public struct State: Equatable {
        
    }
    
    public enum Action: Sendable, ViewAction {
        case onAppear
        case view(View)
        
        @CasePathable
        public enum View: Sendable {
            
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .view(let action):
                switch action {
                
                }
            }
        }
    }
}

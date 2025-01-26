//
//  TermFeature.swift
//  Presentation
//
//  Created by 박서연 on 1/26/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

@Reducer
public struct TermFeature {
    @ObservableState
    public struct State: Equatable {
        var view_terms: [Term: Bool] = [:]
        var view_isAllAgreed: Bool {
            view_terms.values.allSatisfy { $0 }
        }
        var isNavigaiton: Bool = false
        
        public init() { }
    }
    
    public enum Action: Equatable {
        case setNavigating
        case view(ViewAction)
        
        public enum ViewAction: Equatable {
            case toggleTerm(Term, Bool)
            case toggleAll(Bool)
            case nextButtonTapped
        }
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let action):
                switch action {
                case .toggleAll(let isAgreed):
                    state.view_terms.keys.forEach { state.view_terms[$0] = isAgreed }
                    return .none
                    
                case .toggleTerm(let term, let isAgreed):
                    state.view_terms[term] = isAgreed
                    return .none
                    
                case .nextButtonTapped:
                    return .send(.setNavigating)
                }
                
            case .setNavigating:
                return .none
            }
        }
    }
}

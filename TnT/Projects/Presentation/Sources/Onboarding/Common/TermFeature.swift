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
        var view_terms: [Term: Bool]
        var view_isAllAgreed: Bool {
            view_terms.values.allSatisfy { $0 }
        }
        var isNavigaiton: Bool = false
        
        public init() {
            self.view_terms = [
                .term: false,
                .personalInfo: false
            ]
        }
    }
    
    public enum Action: Equatable, ViewAction {
        case setNavigating
        case view(View)
        
        public enum View: Equatable {
            case toggleTerm(Term, Bool)
            case toggleAll(Bool)
            case nextButtonTapped
        }
    }
    
    public init() { }
    
    @Dependency(\.dismiss) var dismiss
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
                    return .concatenate(
//                        .run { _ in await self.dismiss() },
                        .send(.setNavigating)
                    )
                }
                
            case .setNavigating:
                return .none
            }
        }
    }
}

public enum Term: CaseIterable {
    case term
    case personalInfo
    
    var id: Int {
        switch self {
        case .term:
            return 0
        case .personalInfo:
            return 1
        }
    }
    
    var title: String {
        switch self {
        case .term:
            return "(필수)서비스 이용약관 동의"
        case .personalInfo:
            return "(필수)개인정보 처리방침 동의"
        }
    }
    
    var url: String {
        switch self {
        case .term:
            return ""
        case .personalInfo:
            return ""
        }
    }
}

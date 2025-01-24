//
//  MakeInvitationCodeFeature.swift
//  Presentation
//
//  Created by 박서연 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

@Reducer
public struct MakeInvitationCodeFeature {
    @ObservableState
    public struct State {
        var inviteCode: String = ""
        
        public init() { }
    }
    
    public enum Action {
        case tappedDeleteButton
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tappedDeleteButton:
                return .none
            }
        }
    }
}

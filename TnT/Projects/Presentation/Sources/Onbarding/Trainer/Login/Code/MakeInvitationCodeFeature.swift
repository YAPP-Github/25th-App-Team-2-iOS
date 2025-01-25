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
    
    public init() { }

    @ObservableState
    public struct State: Equatable {
        var invitationCode: String = "123456"
        
        public init() { }
    }
    
    public enum Action: Equatable {
        case tappedNextButton
        case tappedIssuanceButton
        case copyCode
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tappedNextButton:
                return .none
            
            case .tappedIssuanceButton:
                return .none
                
            case .copyCode:
                UIPasteboard.general.string = state.invitationCode
                return .none
            }
        }
    }
}

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
    public struct State: Equatable {
        var view_invitationCode: String = ""
        
        public init() { }
    }
    
    public enum Action: Equatable {
        case setNavigation
        case view(ViewAction)
        
        public enum ViewAction {
            case tappedNextButton
            case tappedIssuanceButton
            case copyCode
        }
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let view):
                switch view {
                case .copyCode:
                    UIPasteboard.general.string = state.view_invitationCode
                    return .none
                    
                case .tappedIssuanceButton:
                    return .none
                    
                case .tappedNextButton:
                    return .send(.setNavigation)
                }
            case .setNavigation:
                return .none
                
            }
        }
    }
}

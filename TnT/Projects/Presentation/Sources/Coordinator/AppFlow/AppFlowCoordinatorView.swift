//
//  AppFlowCoordinatorView.swift
//  Presentation
//
//  Created by 박민서 on 2/4/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct AppFlowCoordinatorView: View {
    let store: StoreOf<AppFlowCoordinatorFeature>

    public init(store: StoreOf<AppFlowCoordinatorFeature>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            Group {
                if let userType = store.userType {
                    switch userType {
                    case .trainee:
                        if let store = store.scope(state: \.traineeMainState, action: \.subFeature.traineeMainFlow) {
                            TraineeMainFlowView(store: store)
                        }
                    case .trainer:
                        if let store = store.scope(state: \.trainerMainState, action: \.subFeature.trainerMainFlow) {
                            TrainerMainFlowView(store: store)
                        }
                    }
                } else {
                    if let store = store.scope(state: \.onboardingState, action: \.subFeature.onboardingFlow) {
                        OnboardingFlowView(store: store)
                    }
                }
            }
            .animation(.easeInOut, value: store.userType)
            
            // Overlay
            OverlayContainer()
                .environmentObject(OverlayManager.shared)
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

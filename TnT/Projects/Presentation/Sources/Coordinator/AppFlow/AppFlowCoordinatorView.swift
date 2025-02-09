//
//  AppFlowCoordinatorView.swift
//  Presentation
//
//  Created by 박민서 on 2/4/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import DesignSystem

@ViewAction(for: AppFlowCoordinatorFeature.self)
public struct AppFlowCoordinatorView: View {
    @Bindable public var store: StoreOf<AppFlowCoordinatorFeature>

    public init(store: StoreOf<AppFlowCoordinatorFeature>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            if store.view_isSplashActive {
                SplashView()
                    .transition(.opacity)
            } else {
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
                
                OverlayContainer()
                    .environmentObject(OverlayManager.shared)
            }
        }
        .animation(.easeInOut, value: store.view_isSplashActive)
        .onAppear { send(.onAppear) }
        .tPopUp(isPresented: $store.view_isPopUpPresented) {
            .init(
                alertState: .init(
                    title: "세션이 만료되었어요",
                    message: "장시간 미사용으로 로그인 화면으로 이동해요",
                    showAlertIcon: true,
                    buttons: [
                        TPopupAlertState.ButtonState(
                            title: "확인",
                            style: .secondary,
                            action: .init(action: {
                                send(.tapSessionExpiredPopupConfirmButton)
                            })
                        )
                    ]
                )
            )
        }
    }
}

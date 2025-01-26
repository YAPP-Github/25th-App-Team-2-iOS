//
//  UserTypeSelectionView.swift
//  Presentation
//
//  Created by 박민서 on 1/17/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import Domain
import DesignSystem

/// 역할 선택 화면을 담당하는 View입니다.
@ViewAction(for: UserTypeSelectionFeature.self)
public struct UserTypeSelectionView: View {
    
    @Bindable public var store: StoreOf<UserTypeSelectionFeature>
    
    /// `UserTypeSelectionView`의 생성자
    /// - Parameter store: `UserTypeSelectionFeature`의 상태를 관리하는 `Store`
    public init(store: StoreOf<UserTypeSelectionFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            VStack {
                
                Spacer(minLength: 60)
                
                VStack(spacing: 48) {
                    Header()
                    
                    ImageSection()
                    
                    ButtonSection()
                }
                
                Spacer()
            }
            .safeAreaInset(edge: .bottom) {
                TBottomButton(
                    title: "다음",
                    isEnable: true
                ) {
                    send(.tapNextButton)
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
            .navigationDestination(
                isPresented: $store.view_isNavigating
            ) {
                CreateProfileView(
                    store: .init(initialState: CreateProfileFeature.State(userType: .trainee)) {
                        CreateProfileFeature()
                    })
            }
        }
    }
    
    @ViewBuilder
    private func Header() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("안녕하세요!\n어떤 회원으로 이용하시겠어요?")
                .typographyStyle(.heading2, with: .neutral950)
            Text("트레이너와 트레이니 중 선택해주세요.")
                .typographyStyle(.body1Medium, with: .neutral500)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
    }
    
    @ViewBuilder
    private func ImageSection() -> some View {
        Image(store.userType == .trainer
              ? .imgOnboardingTrainer
              : .imgOnboardingTrainee
        )
        .resizable()
        .frame(width: 310, height: 310)
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func ButtonSection() -> some View {
        HStack(spacing: 8) {
            TButton(
                title: UserType.trainer.koreanName,
                config: .large,
                state: store.userType == UserType.trainer
                ? .default(.red(isEnabled: true))
                : .default(.outline(isEnabled: true)),
                action: {
                    send(.tapUserTypeButton(.trainer), animation: .easeInOut(duration: 0.5))
                }
            )
            
            TButton(
                title: UserType.trainee.koreanName,
                config: .large,
                state: store.userType == UserType.trainee
                ? .default(.red(isEnabled: true))
                : .default(.outline(isEnabled: true)),
                action: {
                    send(.tapUserTypeButton(.trainee), animation: .easeInOut(duration: 0.5))
                }
            )
        }
        .padding(.horizontal, 20)
    }
}

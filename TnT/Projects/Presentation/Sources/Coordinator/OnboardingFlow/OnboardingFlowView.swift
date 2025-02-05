//
//  OnboardingNavigationView.swift
//  Presentation
//
//  Created by 박민서 on 2/4/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import DesignSystem

public struct OnboardingFlowView: View {
    @Bindable var store: StoreOf<OnboardingFlowFeature>

    public init(store: StoreOf<OnboardingFlowFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            EmptyView()
        } destination: { store in
            switch store.case {
                // MARK: Common
            case .snsLogin(let store):
                LoginView(store: store)
            case .term(let store):
                TermView(store: store)
            case .userTypeSelection(let store):
                UserTypeSelectionView(store: store)
            case .createProfile(let store):
                CreateProfileView(store: store)
                
                // MARK: Trainer
            case .trainerSignUpComplete(let store):
                TrainerSignUpCompleteView(store: store)
            case .trainerMakeInvitationCode(let store):
                MakeInvitationCodeView(store: store)
            case .trainerConnectedTraineeProfile(let store):
                ConnectedTraineeProfileView(store: store)
                
                // MARK: Trainee
            case .traineeBasicInfoInput(let store):
                TraineeBasicInfoInputView(store: store)
            case .traineeTrainingPurpose(let store):
                TraineeTrainingPurposeView(store: store)
            case .traineePrecautionInput(let store):
                TraineePrecautionInputView(store: store)
            case .traineeProfileCompletion(let store):
                TraineeProfileCompletionView(store: store)
            case .traineeInvitationCodeInput(let store):
                TraineeInvitationCodeInputView(store: store)
            case .traineeTrainingInfoInput(let store):
                TraineeTrainingInfoInputView(store: store)
            case .traineeConnectionComplete(let store):
                TraineeConnectionCompleteView(store: store)
            }
        }
    }
}

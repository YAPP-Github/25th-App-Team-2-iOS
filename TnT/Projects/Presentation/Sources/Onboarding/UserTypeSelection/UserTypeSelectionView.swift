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
    
    public var store: StoreOf<UserTypeSelectionFeature>
    
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
                    Header
                    
                    ImageSection
                    
                    ButtonSection
                }
                
                Spacer()
                
                BottomTempButton {
                    send(.tapNextButton)
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
            .navigationDestination(
                isPresented: Binding(get: { store.viewState.isNavigating }, set: { store.send(.setNavigating($0))})
            ) {
                CreateProfileView(
                    store: .init(initialState: CreateProfileFeature.State(userType: .trainee)) {
                        CreateProfileFeature()
                    })
            }
        }
    }
}

// MARK: - SubViews
private extension UserTypeSelectionView {
    var Header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("안녕하세요!\n어떤 회원으로 이용하시겠어요?")
                .typographyStyle(.heading2, with: .neutral950)
            Text("트레이너와 트레이니 중 선택해주세요.")
                .typographyStyle(.body1Medium, with: .neutral500)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
    }
    
    var ImageSection: some View {
        Group {
            if store.userType == .trainer {
                Image(.imgOnboardingTrainer)
                    .resizable()
            } else {
                Image(.imgOnboardingTrainee)
                    .resizable()
            }
        }
        .frame(width: 310, height: 310)
        .padding(.horizontal, 20)
    }
    
    var ButtonSection: some View {
        HStack(spacing: 8) {
            TempButton(
                isSelected: store.userType == UserType.trainer,
                title: UserType.trainer.koreanName,
                action: { send(.tapUserTypeButton(.trainer), animation: .easeInOut(duration: 0.5)) }
            )
            TempButton(
                isSelected: store.userType == UserType.trainee,
                title: UserType.trainee.koreanName,
                action: { send(.tapUserTypeButton(.trainee), animation: .easeInOut(duration: 0.5)) }
            )
        }
        .padding(.horizontal, 20)
    }
}

// TODO: 버튼 컴포넌트 나오면 대체
private extension UserTypeSelectionView {
    struct TempButton: View {
        var isSelected: Bool = false
        var title: String
        let action: (() -> Void)
        
        var body: some View {
            Button(action: {
                action()
            }) {
                Text(title)
                    .typographyStyle(.body1Medium, with: isSelected ? .red600 : .neutral500)
                    .padding(.vertical, 16)
                    .frame(height: 58)
                    .frame(maxWidth: .infinity)
                    .background(isSelected ? Color.red50 : .clear)
                    .cornerRadius(16)
                    .overlay(
                      RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color.red400 : Color.neutral300, lineWidth: isSelected ? 1.5 : 1.0)
                    )
            }
        }
    }
    
    struct BottomTempButton: View {
        let action: (() -> Void)
        
        var body: some View {
            Button(action: {
                action()
            }) {
                Text("다음")
                    .typographyStyle(.heading4, with: .neutral50)
                    .padding(.top, 20)
                    .padding(.bottom, 53)
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .background(Color.neutral900)
            }
        }
    }
}

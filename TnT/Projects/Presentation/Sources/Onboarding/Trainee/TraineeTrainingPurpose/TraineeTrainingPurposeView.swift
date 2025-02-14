//
//  TraineeTrainingPurposeView.swift
//  Presentation
//
//  Created by 박민서 on 1/25/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import Domain
import DesignSystem

/// 트레이니의 PT 목적 선택 화면
/// - 사용자가 PT를 받는 목적을 선택하는 화면
/// - 다중 선택 가능
@ViewAction(for: TraineeTrainingPurposeFeature.self)
public struct TraineeTrainingPurposeView: View {
    
    /// 두 개의 열을 가지는 PT 목적 선택 `LazyVGrid`을 위한 레이아웃 설정
    private let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    @Bindable public var store: StoreOf<TraineeTrainingPurposeFeature>
    @Environment(\.dismiss) var dismiss: DismissAction
    
    /// `TraineeTrainingPurposeView` 생성자
    /// - Parameter store: `TraineeTrainingPurposeFeature`와 연결된 Store
    public init(store: StoreOf<TraineeTrainingPurposeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            TNavigation(type: .LButton(leftImage: .icnArrowLeft), leftAction: {
                dismiss()
            })
            
            Header()
                .padding(.bottom, 32)
            
            selectSection()
                
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .keyboardDismissOnTap()
        .bottomFixWith {
            TBottomButton(
                title: "다음",
                isEnable: store.view_isNextButtonEnabled
            ) {
                send(.tapNextButton)
            }
            .padding(.bottom, .safeAreaBottom)
        }
    }
    
    // MARK: - Sections
    @ViewBuilder
    private func Header() -> some View {
        VStack(spacing: 12) {
            // 페이지 인디케이터
            HStack(spacing: 4) {
                ForEach(1...4, id: \.self) { num in
                    TPageIndicator(pageNumber: num, isCurrent: num == 3)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            
            TInfoTitleHeader(title: "PT를 받는 목적에 대해\n알려주세요!", subTitle: "다중 선택이 가능해요.")
        }
        .padding(.vertical, 12)
    }
    
    @ViewBuilder
    private func selectSection() -> some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(TrainingPurpose.allCases, id: \.self) { purpose in
                TButton(
                    title: purpose.koreanName,
                    config: .xLarge,
                    state: store.selectedPurposes.contains(purpose)
                    ? .default(.red(isEnabled: true))
                    : .default(.outline(isEnabled: true)),
                    action: {
                        send(.tapPurposeButton(purpose))
                    }
                )
            }
        }
        .padding(.horizontal, 20)
    }
}

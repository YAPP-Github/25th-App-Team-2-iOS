//
//  TraineeTrainingInfoInputView.swift
//  Presentation
//
//  Created by 박민서 on 1/27/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import Domain
import DesignSystem

/// 회원 기본 정보를 입력하는 화면
/// - 생년월일, 키, 체중 입력을 포함
/// - 생년월일 입력 시 DatePicker 표시
@ViewAction(for: TraineeTrainingInfoInputFeature.self)
public struct TraineeTrainingInfoInputView: View {
    
    @Bindable public var store: StoreOf<TraineeTrainingInfoInputFeature>
    @FocusState private var focusedField: Field?
    @Environment(\.dismiss) var dismiss: DismissAction
    
    /// `TraineeTrainingInfoInputView` 생성자
    /// - Parameter store: `TraineeTrainingInfoInputFeature`와 연결된 Store
    public init(store: StoreOf<TraineeTrainingInfoInputFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            TNavigation(
                type: .LButtonWithTitle(leftImage: .icnArrowLeft, centerTitle: "수업 정보 추가"),
                leftAction: { dismiss() }
            )
            
            TInfoTitleHeader(title: "\(store.trainerName) 트레이너와\n언제부터 함께하셨나요?")
                .padding(.top, 24)
                .padding(.bottom, 48)
            
            TextFieldSection()
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .keyboardDismissOnTap()
        .safeAreaInset(edge: .bottom) {
            if store.view_focusField == nil {
                TBottomButton(
                    title: "다음",
                    isEnable: store.view_isNextButtonEnabled
                ) {
                    send(.tapNextButton)
                }
            }
        }
        .sheet(isPresented: $store.view_isDatePickerPresented) {
            TDatePickerView(
                title: "PT 시작일",
                monthFormatter: {
                    TDateFormatUtility.formatter(for: .yyyy년_MM월).string(from: $0)
                }
            ) { date in
                send(.tapStartDatePickerDoneButton(date))
            }
            .autoSizingBottomSheet(presentationDragIndicator: .hidden)
            .interactiveDismissDisabled(true)
        }
        .onChange(of: focusedField) { oldValue, newValue in
            if oldValue != newValue {
                send(.setFocus(oldValue, newValue))
            }
        }
    }
    
    // MARK: - Sections
    @ViewBuilder
    private func TextFieldSection() -> some View {
        VStack(spacing: 48) {
            TTextField(
                placeholder: Date().toString(format: .yyyyMMddSlash),
                text: $store.startDate,
                textFieldStatus: $store.view_startDateStatus
            )
            .withSectionLayout(header: .init(isRequired: true, title: "PT 시작일", limitCount: nil, textCount: nil))
            .focused($focusedField, equals: .startDate)
            .allowsHitTesting(false)
            .overlay(
                Rectangle()
                    .fill(Color.clear)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture { send(.tapStartDateTextField) }
            )
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            
            HStack(alignment: .bottom, spacing: 12) {
                TTextField(
                    placeholder: "0",
                    text: $store.currentCount,
                    textFieldStatus: $store.view_currentCountStatus,
                    rightView: {
                        TTextField.RightView(style: .unit(text: "회", status: .filled))
                    }
                )
                .withSectionLayout(
                    header: .init(isRequired: true, title: "현재 완료 회차", limitCount: nil, textCount: nil)
                )
                .focused($focusedField, equals: .currentCount)
                .keyboardType(.numberPad)
                
                Text("/")
                    .typographyStyle(.body1Medium, with: .neutral600)
                    .padding(8)
                
                TTextField(
                    placeholder: "0",
                    text: $store.totalCount,
                    textFieldStatus: $store.view_totalCountStatus,
                    rightView: {
                        TTextField.RightView(style: .unit(text: "회", status: .filled))
                    }
                )
                .withSectionLayout(
                    header: .init(isRequired: true, title: "총 등록 회차", limitCount: nil, textCount: nil)
                )
                .focused($focusedField, equals: .totalCount)
                .keyboardType(.numberPad)
            }
            .padding(.horizontal, 20)
        }
    }
}

public extension TraineeTrainingInfoInputView {
    enum Field: Sendable, Hashable {
        case startDate
        case currentCount
        case totalCount
    }
}

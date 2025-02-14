//
//  TraineeBasicInfoInputView.swift
//  Presentation
//
//  Created by 박민서 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import Domain
import DesignSystem

/// 회원 기본 정보를 입력하는 화면
/// - 생년월일, 키, 체중 입력을 포함
/// - 생년월일 입력 시 DatePicker 표시
@ViewAction(for: TraineeBasicInfoInputFeature.self)
public struct TraineeBasicInfoInputView: View {
    
    @Bindable public var store: StoreOf<TraineeBasicInfoInputFeature>
    @FocusState private var focusedField: Field?
    @Environment(\.dismiss) var dismiss: DismissAction
    
    /// `TraineeBasicInfoInputView` 생성자
    /// - Parameter store: `TraineeBasicInfoInputFeature`와 연결된 Store
    public init(store: StoreOf<TraineeBasicInfoInputFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            TNavigation(type: .LButton(leftImage: .icnArrowLeft), leftAction: {
                dismiss()
            })
            
            Header()
                .padding(.bottom, 32)
            
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
                isCustom: false,
                selectedDate: TraineeBasicInfoInputFeature.defaultDatePickerDate,
                currentPageDate: TraineeBasicInfoInputFeature.defaultDatePickerDate,
                title: "생년월일",
                monthFormatter: {
                    TDateFormatUtility.formatter(for: .yyyy년_MM월).string(from: $0)
                }
            ) { date in
                send(.tapBirthDatePickerDoneButton(date))
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
    private func Header() -> some View {
        VStack(spacing: 12) {
            // 페이지 인디케이터
            HStack(spacing: 4) {
                ForEach(1...4, id: \.self) { num in
                    TPageIndicator(pageNumber: num, isCurrent: num == 2)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            
            TInfoTitleHeader(title: "회원님의 기본 정보를\n입력해주세요", subTitle: "PT에 참고할 기본 정보에요!")
        }
        .padding(.vertical, 12)
    }
    
    @ViewBuilder
    private func TextFieldSection() -> some View {
        VStack(spacing: 48) {
            TTextField(
                placeholder: TraineeBasicInfoInputFeature.defaultDatePickerDate.toString(format: .yyyyMMddSlash),
                text: $store.birthDate,
                textFieldStatus: $store.view_birthDateStatus
            )
            .withSectionLayout(header: .init(isRequired: false, title: "생년월일", limitCount: nil, textCount: nil))
            .focused($focusedField, equals: .birthDate)
            .allowsHitTesting(false)
            .overlay(
                Rectangle()
                    .fill(Color.clear)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture { send(.tapBirthDateTextField) }
            )
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            
            HStack(spacing: 12) {
                TTextField(
                    placeholder: "0",
                    text: $store.height,
                    textFieldStatus: $store.view_heightStatus,
                    rightView: {
                        TTextField.RightView(style: .unit(text: UnitType.height.koreaUnit, status: .filled))
                    }
                )
                .withSectionLayout(
                    header: .init(isRequired: false, title: "키", limitCount: nil, textCount: nil),
                    footer: .init(footerText: "잘못된 수치를 입력했어요", status: store.view_heightStatus)
                )
                .focused($focusedField, equals: .height)
                .keyboardType(.numberPad)
                
                TTextField(
                    placeholder: "00.0",
                    text: $store.weight,
                    textFieldStatus: $store.view_weightStatus,
                    rightView: {
                        TTextField.RightView(style: .unit(text: UnitType.weight.koreaUnit, status: .filled))
                    }
                )
                .withSectionLayout(
                    header: .init(isRequired: false, title: "체중", limitCount: nil, textCount: nil),
                    footer: .init(footerText: "잘못된 수치를 입력했어요", status: store.view_weightStatus)
                )
                .focused($focusedField, equals: .weight)
                .keyboardType(.decimalPad)
            }
            .padding(.horizontal, 20)
        }
    }
}

public extension TraineeBasicInfoInputView {
    enum Field: Sendable, Hashable {
        case birthDate
        case height
        case weight
    }
}

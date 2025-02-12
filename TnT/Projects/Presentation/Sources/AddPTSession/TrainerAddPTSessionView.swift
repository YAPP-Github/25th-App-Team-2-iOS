//
//  TrainerAddPTSessionView.swift
//  Presentation
//
//  Created by 박민서 on 2/6/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import Domain
import DesignSystem

/// PT 수업을 추가하는 화면
@ViewAction(for: TrainerAddPTSessionFeature.self)
public struct TrainerAddPTSessionView: View {
    
    @Bindable public var store: StoreOf<TrainerAddPTSessionFeature>
    @FocusState private var focusedField: Field?
    @Environment(\.dismiss) var dismiss: DismissAction
    
    /// `TraineeBasicInfoInputView` 생성자
    /// - Parameter store: `TraineeBasicInfoInputFeature`와 연결된 Store
    public init(store: StoreOf<TrainerAddPTSessionFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            TNavigation(
                type: .LButtonWithTitle(
                    leftImage: .icnArrowLeft,
                    centerTitle: "수업 추가하기"
                ),
                leftAction: { send(.tapNavBackButton) }
            )
            TDivider(height: 1, color: .neutral200)
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Header()
                        .padding(.bottom, 28)
                    
                    FieldSection()
                    
                    Spacer()
                }
                .padding(.bottom, .safeAreaBottom + 20)
            }
        }
        .onTapGesture { focusedField = nil }
        .navigationBarBackButtonHidden()
        .keyboardDismissOnTap()
        .safeAreaInset(edge: .bottom) {
            if store.view_focusField == nil {
                TBottomButton(
                    title: "완료",
                    isEnable: store.view_isSubmitButtonEnabled
                ) {
                    send(.tapSubmitButton)
                }
            }
        }
        .sheet(item: $store.view_bottomSheetItem) { item in
            switch item {
            case .traineeList:
                TrainerSelectSessionTraineeView(
                    traineeList: store.traineeList.map { item in
                        (listItem: item, action: { send(.tapTraineeAtBottomSheet(item)) })
                    },
                    selectedTraineeId: store.trainee?.id
                )
            case .datePicker(let field):
                TDatePickerView(
                    title: field.title,
                    monthFormatter: { TDateFormatUtility.formatter(for: .yyyy년_MM월).string(from: $0) },
                    buttonAction: {
                        send(.tapBottomSheetSubmitButton(.ptDate, $0))
                    }
                )
                .autoSizingBottomSheet(presentationDragIndicator: .hidden)
            case .timePicker(let field):
                TTimePickerView(
                    selectedTime: (field == .startTime ? store.startTime : store.endTime) ?? .now,
                    title: field.title,
                    minuteStep: 10,
                    buttonAction: {
                        send(.tapBottomSheetSubmitButton(field, $0))
                    }
                )
                .autoSizingBottomSheet(presentationDragIndicator: .hidden)
            }
        }
        .tPopUp(isPresented: $store.view_isPopUpPresented) {
            PopUpView()
        }
        .onChange(of: store.view_bottomSheetItem) { oldValue, newValue in
            if oldValue != newValue {
                send(.setFocus(oldValue?.field, newValue?.field))
            }
        }
        .onChange(of: focusedField) { oldValue, newValue in
            if oldValue != newValue {
                send(.setFocus(oldValue, newValue))
            }
        }
        .onAppear { send(.onAppear) }
    }
    
    // MARK: - Sections
    @ViewBuilder
    private func Header() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("언제 수업할까요?")
                .typographyStyle(.heading2, with: .neutral950)
            Text("일정을 등록하면 회원에게도 일정이 등록돼요")
                .typographyStyle(.body2Medium, with: .neutral500)
        }
        .padding(20)
    }
    
    @ViewBuilder
    private func FieldSection() -> some View {
        VStack(spacing: 48) {
            // TraineeDropDown
            TTextField(
                placeholder: "회원을 입력해주세요",
                text: Binding(get: {
                    store.trainee?.name ?? ""
                }, set: { _ in }),
                textFieldStatus: $store.view_traineeStatus
            ) {
                TTextField.RightView(
                    style: .dropDown(
                        tintColor: focusedField == .ptDate ? Color.neutral600 : Color.neutral400,
                        tapAction: { }
                    )
                )
            }
            .withSectionLayout(header: .init(isRequired: true, title: "회원선택", limitCount: nil, textCount: nil))
            .focused($focusedField, equals: .ptDate)
            .allowsHitTesting(false)
            .overlay(
                Rectangle()
                    .fill(Color.clear)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture { send(.tapTraineeDropDown) }
            )
            .frame(maxWidth: .infinity)
            
            // PtDateDropDown
            TTextField(
                placeholder: "2025/01/30",
                text: Binding(get: {
                    store.ptDate?.toString(format: .yyyyMMddSlash) ?? ""
                }, set: { _ in }),
                textFieldStatus: $store.view_ptDateStatus
            )
            .withSectionLayout(header: .init(isRequired: true, title: "PT 날짜", limitCount: nil, textCount: nil))
            .focused($focusedField, equals: .trainee)
            .allowsHitTesting(false)
            .overlay(
                Rectangle()
                    .fill(Color.clear)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture { send(.tapPtDateDropDown) }
            )
            .frame(maxWidth: .infinity)
            
            // StartTime ~ EndTime
            HStack(alignment: .bottom, spacing: 12) {
                // StartTime
                TTextField(
                    placeholder: "09:00",
                    text: Binding(get: {
                        store.startTime?.toString(format: .HHmm) ?? ""
                    }, set: { _ in }),
                    textFieldStatus: $store.view_startTimeStatus
                )
                .withSectionLayout(header: .init(isRequired: true, title: "시작 시간", limitCount: nil, textCount: nil))
                .focused($focusedField, equals: .trainee)
                .allowsHitTesting(false)
                .overlay(
                    Rectangle()
                        .fill(Color.clear)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture { send(.tapStartTimeDropDown) }
                )
                .frame(maxWidth: .infinity)
                
                Text("~")
                    .typographyStyle(.body1Medium, with: .neutral600)
                    .padding(8)
                
                // EndTime
                TTextField(
                    placeholder: "10:00",
                    text: Binding(get: {
                        store.endTime?.toString(format: .HHmm) ?? ""
                    }, set: { _ in }),
                    textFieldStatus: $store.view_endTimeStatus
                )
                .withSectionLayout(header: .init(isRequired: true, title: "종료 시간", limitCount: nil, textCount: nil))
                .focused($focusedField, equals: .endTime)
                .allowsHitTesting(false)
                .overlay(
                    Rectangle()
                        .fill(Color.clear)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture { send(.tapEndTimeDropDown) }
                )
                .frame(maxWidth: .infinity)
            }
            
            // Time
            if store.startTime != nil {
                VStack(alignment: .leading, spacing: 16) {
                    Text("수업 시간")
                        .typographyStyle(.body1Bold, with: .neutral900)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(TrainerAddPTSessionFeature.SessionTime.allCases, id: \.rawValue) { interval in
                            Button(action: { send(.tapSessionIntervalButton(interval)) }) {
                                Text("+\(interval.rawValue)분")
                                    .typographyStyle(.body1Medium, with: store.view_sessionTime == interval.rawValue ? Color.red600 : Color.neutral500)
                                    .padding(.vertical, 13)
                                    .padding(.horizontal, 33)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(store.view_sessionTime == interval.rawValue ? Color.red400 : Color.neutral300, lineWidth: 1.5)
                                            .backgroundStyle(store.view_sessionTime == interval.rawValue ? Color.red50 : Color.common0)
                                    )
                            }
                        }
                    }
                }
            }
            
            // Memo
            TTextEditor(
                placeholder: "PT 수업에서 기억해야 할 것을 메모해보세요",
                text: $store.memo,
                textEditorStatus: $store.view_memoStatus,
                footer: {
                    .init(
                        textLimit: 30,
                        status: $store.view_memoStatus,
                        textCount: store.memo.count,
                        warningText: "30자 미만으로 입력해주세요"
                    )
                }
            )
            .focused($focusedField, equals: .memo)
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func PopUpView() -> some View {
        if let popUp = store.view_popUp {
            let buttons: [TPopupAlertState.ButtonState] = [
                popUp.secondaryAction.map { action in
                    .init(title: "취소", style: .secondary, action: .init(action: { send(action) }))
                },
                .init(title: popUp.primaryTitle, style: .primary, action: .init(action: { send(popUp.primaryAction) }))
            ].compactMap { $0 }
            
            TPopUpAlertView(
                alertState: .init(
                    title: popUp.title,
                    message: popUp.message,
                    showAlertIcon: popUp.showAlertIcon,
                    buttons: buttons
                )
            )
        } else {
            EmptyView()
        }
    }
}

public extension TrainerAddPTSessionView {
    enum Field: Sendable, Hashable {
        case trainee
        case ptDate
        case startTime
        case endTime
        case memo
        
        var title: String {
            switch self {
                
            case .trainee:
                return "회원 선택하기"
            case .ptDate:
                return "PT날짜 선택하기"
            case .startTime:
                return "시작 시간 선택하기"
            case .endTime:
                return "종료 시간 선택하기"
            case .memo:
                return "메모하기"
            }
        }
    }
}

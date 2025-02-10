//
//  TraineeAddDietRecordView.swift
//  Presentation
//
//  Created by 박민서 on 2/10/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import PhotosUI

import Domain
import DesignSystem

/// 식단 기록을 추가하는 화면
@ViewAction(for: TraineeAddDietRecordFeature.self)
public struct TraineeAddDietRecordView: View {
    
    @Bindable public var store: StoreOf<TraineeAddDietRecordFeature>
    @FocusState private var focusedField: Field?
    @Environment(\.dismiss) var dismiss: DismissAction
    
    /// `TraineeAddDietRecordView` 생성자
    /// - Parameter store: `TraineeAddDietRecordFeature`와 연결된 Store
    public init(store: StoreOf<TraineeAddDietRecordFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            TNavigation(
                type: .LButtonWithTitle(
                    leftImage: .icnArrowLeft,
                    centerTitle: "식단 기록"
                ),
                leftAction: { send(.tapNavBackButton) }
            )
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Header()
                        .padding(.bottom, 28)
                    
                    VStack(spacing: 48) {
                        DietDateSection()
                        DietTimeSection()
                        DietTypeSection()
                        DietPhotoSection()
                        DietInfoSection()
                    }
                    .padding(.horizontal, 20)
                    
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
            case .datePicker(let field):
                TDatePickerView(
                    title: field.title,
                    monthFormatter: { TDateFormatUtility.formatter(for: .yyyy년_MM월).string(from: $0) },
                    buttonAction: {
                        send(.tapBottomSheetSubmitButton(.dietDate, $0))
                    }
                )
                .autoSizingBottomSheet(presentationDragIndicator: .hidden)
            case .timePicker(let field):
                TTimePickerView(
                    selectedTime: store.dietDate ?? .now,
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
    }
    
    // MARK: - Sections
    @ViewBuilder
    private func Header() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("오늘의 식단을 기록해 주세요")
                .typographyStyle(.heading2, with: .neutral950)
            Text("식단을 기록하면 트레이너가 피드백을 남길 수 있어요")
                .typographyStyle(.body2Medium, with: .neutral500)
        }
        .padding(20)
    }

    @ViewBuilder
    private func DietDateSection() -> some View {
        TTextField(
            placeholder: "2025/11/19",
            text: Binding(get: {
                store.dietDate?.toString(format: .yyyyMMddSlash) ?? ""
            }, set: { _ in }),
            textFieldStatus: $store.view_dietDateStatus
        )
        .withSectionLayout(header: .init(isRequired: true, title: "식사 날짜", limitCount: nil, textCount: nil))
        .focused($focusedField, equals: .dietDate)
        .allowsHitTesting(false)
        .overlay(
            Rectangle()
                .fill(Color.clear)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture { send(.tapDietDateDropDown) }
        )
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func DietTimeSection() -> some View {
        TTextField(
            placeholder: "오전 11:16",
            text: Binding(get: {
                store.dietTime?.toString(format: .a_HHmm) ?? ""
            }, set: { _ in }),
            textFieldStatus: $store.view_dietTimeStatus
        )
        .withSectionLayout(header: .init(isRequired: true, title: "식사 시간", limitCount: nil, textCount: nil))
        .focused($focusedField, equals: .dietTime)
        .allowsHitTesting(false)
        .overlay(
            Rectangle()
                .fill(Color.clear)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture { send(.tapDietTimeDropDown) }
        )
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func DietTypeSection() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            TTextField.Header(isRequired: true, title: "카테고리", limitCount: nil, textCount: nil)
            
            HStack(spacing: 8) {
                ForEach(DietType.allCases, id: \.koreanName) { item in
                    Button(action: {
                        send(.tapDietTypeButton(item))
                    }) {
                        Text(item.koreanName)
                            .typographyStyle(
                                .body1Medium,
                                with: store.dietType == item ? .red600 : .neutral500
                            )
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(store.dietType == item ? Color.red50 : Color.common0)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(
                                        store.dietType == item ? Color.red400 : Color.neutral300,
                                        lineWidth: 1.5
                                    )
                            )
                            .frame(height: 40)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func DietPhotoSection() -> some View {
        Group {
            if let imageData = store.dietImageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(.rect(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.neutral300, lineWidth: 1.5)
                    )
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.neutral300, lineWidth: 1.5)
                        .frame(width: 80, height: 80)
                        
                    Image(.icnImage)
                    .resizable()
                    .frame(width: 18, height: 18)
                }
                .frame(width: 80, height: 80)
            }
        }
        .frame(width: 90, height: 90)
        .overlay(alignment: .bottomTrailing) {
            PhotosPicker(
                selection: $store.view_photoPickerItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                ZStack {
                    Circle()
                        .fill(Color.neutral900)
                        .frame(width: 28, height: 28)
                    Image(.icnWriteWhite)
                        .resizable()
                        .frame(width: 16, height: 16)
                }
            }
        }
    }
    
    @ViewBuilder
    private func DietInfoSection() -> some View {
        TTextEditor(
            placeholder: "식단에 대한 정보를 입력해주세요!",
            text: $store.dietInfo,
            textEditorStatus: $store.view_dietInfoStatus,
            footer: {
                .init(
                    textLimit: 100,
                    status: $store.view_dietInfoStatus,
                    textCount: store.dietInfo.count,
                    warningText: "100자 미만으로 입력해주세요"
                )
            }
        )
        .focused($focusedField, equals: .dietInfo)
    }
    
    @ViewBuilder
    private func PopUpView() -> some View {
        if let popUp = store.view_popUp {
            let buttons: [TPopupAlertState.ButtonState] = [
                popUp.secondaryAction.map { action in
                    .init(title: "종료", style: .secondary, action: .init(action: { send(action) }))
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

public extension TraineeAddDietRecordView {
    enum Field: Sendable, Hashable {
        case dietDate
        case dietTime
        case dietInfo
        
        var title: String {
            switch self {
            case .dietDate:
                return "식단 날짜 선택하기"
            case .dietTime:
                return "식단 시간 선택하기"
            case .dietInfo:
                return "식단 정보"
            }
        }
    }
}

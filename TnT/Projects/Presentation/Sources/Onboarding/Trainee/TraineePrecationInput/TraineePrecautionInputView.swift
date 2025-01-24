//
//  TraineePrecautionInputView.swift
//  Presentation
//
//  Created by 박민서 on 1/25/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import Domain
import DesignSystem

/// 트레이너에게 전달할 주의사항 입력 화면
/// - 사용자가 입력한 주의사항을 텍스트 에디터를 통해 작성
@ViewAction(for: TraineePrecautionInputFeature.self)
public struct TraineePrecautionInputView: View {
    
    @Bindable public var store: StoreOf<TraineePrecautionInputFeature>
    @FocusState private var focusedField: Bool
    @Environment(\.dismiss) var dismiss: DismissAction
    
    /// `TraineePrecautionInputView` 생성자
    /// - Parameter store: `TraineePrecautionInputFeature`와 연결된 Store
    public init(store: StoreOf<TraineePrecautionInputFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            TNavigation(type: .LButton(leftImage: .icnArrowLeft), leftAction: {
                dismiss()
            })
            
            Header
                .padding(.bottom, 32)
            
            TextEditorSection
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .keyboardDismissOnTap()
        .safeAreaInset(edge: .bottom) {
            if store.view_focusField == false {
                TBottomButton(
                    title: "다음",
                    state: store.view_isNextButtonEnabled ? .true : .false
                ) {
                    send(.tapNextButton)
                }
            }
        }
        .onChange(of: focusedField) { _, newFocus in
            print(newFocus)
            send(.setFocus(newFocus))
        }
    }
}

private extension TraineePrecautionInputView {
    var Header: some View {
        VStack(spacing: 12) {
            // 페이지 인디케이터
            HStack(spacing: 4) {
                ForEach(1...4, id: \.self) { num in
                    TPageIndicator(pageNumber: num, isCurrent: num == 4)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            
            TInfoTitleHeader(title: "트레이너가 꼭 알아야할\n주의사항이 있나요?", subTitle: "트레이너에게 알려드릴게요.")
        }
        .padding(.vertical, 12)
    }
    
    var TextEditorSection: some View {
        TTextEditor(
            placeholder: "내용을 입력해주세요",
            text: $store.precaution,
            textEditorStatus: $store.view_editorStatus,
            footer: {
                .init(
                    textLimit: UserPolicy.maxPrecautionLength,
                    status: $store.view_editorStatus,
                    textCount: store.precaution.count
                )
            }
        )
        .padding(.horizontal, 20)
        .focused($focusedField)
    }
}

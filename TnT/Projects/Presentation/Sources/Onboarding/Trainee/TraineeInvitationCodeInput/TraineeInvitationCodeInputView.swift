//
//  TraineeInvitationCodeInputView.swift
//  Presentation
//
//  Created by 박민서 on 1/26/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import Domain
import DesignSystem

/// 트레이너 초대 코드를 입력하는 화면
@ViewAction(for: TraineeInvitationCodeInputFeature.self)
public struct TraineeInvitationCodeInputView: View {
    
    @Bindable public var store: StoreOf<TraineeInvitationCodeInputFeature>
    @FocusState private var focusedField: Bool
    
    /// `TraineeInvitationCodeInputView` 생성자
    /// - Parameter store: `TraineeInvitationCodeInputFeature`와 연결된 Store
    public init(store: StoreOf<TraineeInvitationCodeInputFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // TODO: #30 PR 머지 후 RTextWithTitle로 변경
            TNavigation(type: .LRButtonWithTitle(leftImage: .icnListFilled, centerTitle: "연결하기", rightImage: .icnListFilled), rightAction: {
                
            })
            .padding(.bottom, 24)
            
            Header()
                .padding(.bottom, 48)
            
            TextFieldSection()
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .keyboardDismissOnTap()
        .safeAreaInset(edge: .bottom) {
            if store.view_isFieldFocused == false {
                TBottomButton(
                    title: "다음",
                    isEnable: store.view_isNextButtonEnabled
                ) {
                    send(.tapNextButton)
                }
            }
        }
        .onChange(of: focusedField) { oldValue, newValue in
            if oldValue != newValue {
                send(.setFocus(newValue))
            }
        }
    }
    
    // MARK: - Sections
    @ViewBuilder
    private func Header() -> some View {
        TInfoTitleHeader(title: "트레이너에게 받은\n초대 코드를 입력해 주세요")
    }
    
    @ViewBuilder
    private func TextFieldSection() -> some View {
        VStack(spacing: 48) {
            TTextField(
                placeholder: "코드를 입력해주세요",
                text: $store.invitationCode,
                textFieldStatus: $store.view_invitationCodeStatus,
                rightView: {
                    TTextField.RightView(
                        style: .button(
                            title: "인증하기",
                            state: store.view_isVerityButtonEnabled
                            ? .default(.primary(isEnabled: true))
                            : .disable(.primary(isEnabled: false)),
                            tapAction: {
                                send(.tapVerifyButton)
                            }
                        )
                    )
                }
            )
            .withSectionLayout(
                header: .init(isRequired: true, title: "내 초대 코드", limitCount: nil, textCount: nil),
                footer: .init(footerText: store.view_textFieldFooterText, status: store.view_invitationCodeStatus)
            )
            .focused($focusedField)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
        }
    }
}

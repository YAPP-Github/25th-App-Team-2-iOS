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
            NavigationBar()
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
        .tPopUp(isPresented: $store.view_isPopupPresented) {
            guard let popUp = store.presentPopUp else {
                return TPopUpAlertView(alertState: .init(title: "Error"))
            }
            switch popUp {
            case .invitePopUp:
                return TrainerInvitePopup()
                
            case .dropAlert:
                return DropAlertPopup()
            }
        }
    }
    
    // MARK: - Sections
    @ViewBuilder
    private func NavigationBar() -> some View {
        switch store.view_navigationType {
        case .newUser:
            TNavigation(
                type: .RTextWithTitle(
                    centerTitle: "연결하기",
                    rightText: "건너뛰기"
                ),
                rightAction: {
                    send(.tapNavBarSkipButton)
                }
            )
        case .existingUser:
            TNavigation(
                type: .LButtonWithTitle(
                    leftImage: .icnArrowLeft,
                    centerTitle: "연결하기"
                ),
                leftAction: {
                    send(.tapNavBarBackButton)
                }
            )
        }
    }
    
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

private extension TraineeInvitationCodeInputView {
    @ViewBuilder
    /// 진입 시 트레이너 초대 코드 권유 팝업
    private func TrainerInvitePopup() -> TPopUpAlertView {
        TPopUpAlertView(
            alertState: .init(
                title: "트레이너에게 받은\n초대 코드를 입력해보세요!",
                message: "트레이너와 연결하지 않을 경우\n일부 기능이 제한될 수 있어요.",
                buttons: [
                    .init(
                        title: "다음에 할게요",
                        style: .secondary,
                        action: .init(action: {
                            send(.tapInvitePopupNextButton)
                        })
                    ),
                    .init(
                        title: "확인",
                        style: .primary,
                        action: .init(action: {
                            send(.tapInvitePopupConfirmButton)
                        })
                    )
                ]
            )
        )
    }
    
    @ViewBuilder
    /// 코드 인증 후 화면을 벗어나려는 경우 팝업
    private func DropAlertPopup() -> TPopUpAlertView {
        TPopUpAlertView(
            alertState: .init(
                title: "트레이너 연결을 중단하시겠어요?",
                message: "중단 시 연결을 처음부터 다시 설정해야 해요",
                showAlertIcon: true,
                buttons: [
                    .init(
                        title: "중단하기",
                        style: .secondary,
                        action: .init(action: {
                            send(.tapDropAlertStopButton)
                        })
                    ),
                    .init(
                        title: "계속 진행",
                        style: .primary,
                        action: .init(action: {
                            send(.tapDropAlertKeepButton)
                        })
                    )
                ]
            )
        )
    }
}

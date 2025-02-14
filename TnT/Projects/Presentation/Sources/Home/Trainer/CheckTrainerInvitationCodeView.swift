//
//  CheckTrainerInvitationCodeView.swift
//  Presentation
//
//  Created by 박서연 on 2/15/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import DesignSystem

@ViewAction(for: CheckTrainerInvitationCodeFeature.self)
struct CheckTrainerInvitationCodeView: View {
    
    @Environment(\.dismiss) var dismiss: DismissAction
    public let store: StoreOf<CheckTrainerInvitationCodeFeature>
    
    public init(store: StoreOf<CheckTrainerInvitationCodeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Header()
            InvitationCode()
        }
        .navigationBarBackButtonHidden()
        .onAppear { send(.onAppear) }
    }
    
    @ViewBuilder
    private func Header() -> some View {
        TNavigation(type: .RButtonWithTitle(centerTitle: "연결하기", rightImage: .icnDelete))
            .rightTap {
                dismiss()
            }
            .padding(.bottom, 24)
    }
    
    @ViewBuilder
    private func InvitationCode() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("생성된 초대코드로\n트레이니가 로그인할 수 있어요")
                .typographyStyle(.heading2, with: .neutral950)
            
            Spacer().frame(height: 48)
            
            VStack(spacing: 15) {
                HStack(spacing: 0) {
                    Text("내 초대 코드")
                        .typographyStyle(.body1Bold, with: .neutral900)
                    Text("*")
                        .typographyStyle(.body1Bold, with: .red500)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                HStack(spacing: 0) {
                    ZStack(alignment: .bottom) {
                        Text("\(store.invitationCode)")
                            .typographyStyle(.body1Medium, with: .neutral600)
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onTapGesture {
                                send(.tapCodeToCopy)
                            }
                        
                        TDivider(height: 1, color: .neutral300)
                    }
                    
                    TButton(
                        title: "코드 재발급",
                        config: .small,
                        state: .default(.gray(isEnabled: true))
                    ) {
                        send(.tappedReissuanceButton)
                    }
                    .frame(width: 82)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

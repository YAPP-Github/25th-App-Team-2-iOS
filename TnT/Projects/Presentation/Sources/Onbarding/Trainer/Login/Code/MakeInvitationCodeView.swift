//
//  MakeInvitationCodeView.swift
//  Presentation
//
//  Created by 박서연 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

public struct MakeInvitationCodeView: View {
    public let store: StoreOf<MakeInvitationCodeFeature>
    
    public init(store: StoreOf<MakeInvitationCodeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            TNavigation(type: .RTextWithTitle(centerTitle: "연결하기", rightText: "건너뛰기"))
                .rightTap {
                    store.send(.tappedNextButton)
                }
                .padding(.bottom, 24)
            
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
                            Text("\(store.state.invitationCode)")
                                .typographyStyle(.body1Medium, with: .neutral600)
                                .padding(8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture {
                                    store.send(.copyCode)
                                }
                            
                            TDivider(height: 1, color: .neutral300)
                        }
                        
                        TButton(
                            title: "코드 재발급",
                            config: .small,
                            state: .default(.gray(isEnabled: true))
                        ) {
                            // 코드 재발급
                            store.send(.tappedIssuanceButton)
                        }
                        .frame(width: 82)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}

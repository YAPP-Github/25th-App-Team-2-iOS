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

struct MakeInvitationCodeView: View {
    public init() { }
    
    public var body: some View {
        VStack(spacing: 0) {
            TNavigation(type: .LButton(leftImage: .icnDelete))
                .leftTap {
                    // 뒤로가기
                }
            
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("트레이니 연결")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .typographyStyle(.body1Semibold, with: .red500)
                    Text("생성된 초대코드로\n트레이니가 로그인할 수 있어요")
                        .typographyStyle(.heading2, with: .neutral950)
                }
                Spacer().frame(height: 48)
                Text("내 초대 코드")
                    .typographyStyle(.body1Bold, with: .neutral900)
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    MakeInvitationCodeView()
}

//
//  LoginMainView.swift
//  Presentation
//
//  Created by 박서연 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import DesignSystem
import SwiftUI

struct LoginMainView: View {
    var body: some View {
        VStack(spacing:0) {
            Spacer().frame(height: 48)
            
            VStack(spacing: 12) {
                Text("만나서 반가워요")
                    .typographyStyle(.body1Medium, with: .neutral500)
                Text("트레이너와 트레이니\n케미 터트리기")
                    .typographyStyle(.heading1, with: .neutral950)
            }
            
            Image(.imgOnboardingLogin)
                .resizable()
                .scaledToFit()
            
            
        }
    }
}

//
//  TimeIndicator.swift
//  DesignSystem
//
//  Created by 박민서 on 2/2/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// Card 우측 상단 - 이모지 + 오후 16:00 ~ 오후 18:00
struct TimeIndicator: View {
    private let timeText: String
    
    init(timeText: String) {
        self.timeText = timeText
    }
    
    var body: some View {
        HStack {
            Spacer()
            HStack(spacing: 4) {
                Image(.icnClock)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 16, height: 16)
                Text(timeText)
                    .typographyStyle(.label2Medium, with: .neutral500)
            }
        }
    }
}

//
//  TraineeRecordStartVeiw.swift
//  Presentation
//
//  Created by 박민서 on 2/2/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

import DesignSystem

/// TraineeHomeView에서 사용하는 기록 선택용 바텀 시트 뷰
struct TraineeRecordStartView: View {
    /// 버튼 아이템 리스트
    var itemContents: [(emoji: String, title: String, action: () -> Void)]
    /// 바텀시트 높이
    @State private var contentHeight: CGFloat = 300
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("어떤 기록을 하시겠어요?")
                .typographyStyle(.heading3, with: .neutral900)
                .padding(20)
            
            VStack(spacing: 12) {
                ForEach(itemContents.indices, id: \.self) { index in
                    let item = itemContents[index]
                    RecordStartButton(action: item.action, emoji: item.emoji, title: item.title)
                }
            }
        }
        .background(
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        contentHeight = proxy.size.height + 50  // ✅ 내부 높이를 측정하여 저장
                    }
                    .onChange(of: proxy.size.height) { _, newHeight in
                        contentHeight = newHeight + 50  // ✅ 높이 변경 감지 시 업데이트
                    }
            }
        )
        .presentationDetents([.height(contentHeight)])  // ✅ 측정한 높이 적용
        .presentationDragIndicator(.visible)
    }
}

private extension TraineeRecordStartView {
    struct RecordStartButton: View {
        let action: () -> Void
        let emoji: String
        let title: String
        
        var body: some View {
            Button(action: action, label: {
                HStack(spacing: 4) {
                    Text(emoji)
                        .typographyStyle(.heading3)
                    Text(title)
                        .typographyStyle(.body1Semibold, with: .neutral600)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
            })
        }
    }
}

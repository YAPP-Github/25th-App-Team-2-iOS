//
//  AlarmCheckView.swift
//  Presentation
//
//  Created by 박민서 on 2/2/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import Domain
import DesignSystem

/// 알람 목록을 입력하는 화면
/// 유저에게 도착한 알람을 표시 - 유저 타입에 따라 분류
@ViewAction(for: AlarmCheckFeature.self)
public struct AlarmCheckView: View {

    @Bindable public var store: StoreOf<AlarmCheckFeature>
    @Environment(\.dismiss) var dismiss: DismissAction
    
    public init(store: StoreOf<AlarmCheckFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            TNavigation(
                type: .LButtonWithTitle(leftImage: .icnArrowLeft, centerTitle: "알림"),
                leftAction: { send(.tapNavBackButton) }
            )
            
            ScrollView {
                AlarmList()
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Sections
    @ViewBuilder
    private func AlarmList() -> some View {
        VStack(spacing: 0) {
            ForEach(store.alarmList, id: \.alarmId) { item in
                AlarmListItem(
                    alarmTypeText: item.alarmTypeText,
                    alarmMainText: item.alarmMainText,
                    alarmTimeText: item.alarmDate.timeAgoDisplay(),
                    alarmSeenBefore: item.alarmSeenBefore
                )
            }
        }
    }
}

private extension AlarmCheckView {
    struct AlarmListItem: View {
        /// 연결 완료, 연결 해제 등
        let alarmTypeText: String
        /// 알람 본문
        let alarmMainText: String
        /// 알람 시각
        let alarmTimeText: String
        /// 알람 확인 여부
        let alarmSeenBefore: Bool
        
        var body: some View {
            HStack(spacing: 16) {
                Image(.icnBombEmpty)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(alarmTypeText)
                            .typographyStyle(.label1Bold, with: .neutral400)
                            .padding(.bottom, 3)
                        Spacer()
                        Text(alarmTimeText)
                            .typographyStyle(.label1Medium, with: .neutral400)
                    }
                    
                    Text(alarmMainText)
                        .typographyStyle(.body2Medium, with: .neutral800)
                }
            }
            .padding(20)
            .background(alarmSeenBefore ? Color.common0 : Color.neutral100)
        }
    }
}

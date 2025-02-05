//
//  TraineeMainNavigationTabView.swift
//  Presentation
//
//  Created by 박민서 on 2/4/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import DesignSystem

@ViewAction(for: TraineeMainTabFeature.self)
public struct TraineeMainTabView: View {
    @Bindable public var store: StoreOf<TraineeMainTabFeature>
    
    public init(store: StoreOf<TraineeMainTabFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            switch store.state {
            case .home:
                if let store = store.scope(state: \.home, action: \.subFeature.homeAction) {
                    TraineeHomeView(store: store)
                }
            case .myPage:
                if let store = store.scope(state: \.myPage, action: \.subFeature.myPageAction) {
                    TraineeMyPageView(store: store)
                }
            }
            
            BottomTabBar()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // MARK: Section
    @ViewBuilder
    private func BottomTabBar() -> some View {
        HStack(alignment: .top) {
            ForEach(TraineeTabInfo.allCases, id: \.hashValue) { tab in
                Spacer()
                TabButton(
                    icon: store.state.tabInfo == tab ? tab.filledIcn : tab.emptyIcn,
                    text: tab.rawValue,
                    action: { send(.selectTab(tab))}
                )
                .frame(maxHeight: .infinity, alignment: .top)
                Spacer()
            }
        }
        .frame(height: 54 + .safeAreaBottom)
        .padding(.horizontal, 24)
        .background(Color.white.shadow(radius: 5).opacity(0.5))
    }
}

private extension TraineeMainTabView {
    struct TabButton: View {
        let icon: ImageResource
        let text: String
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                VStack(spacing: 4) {
                    Image(icon)
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text(text)
                        .typographyStyle(.label2Bold, with: .neutral900)
                }
            }
            .padding(.vertical, 8)
        }
    }
}

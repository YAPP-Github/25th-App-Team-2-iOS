//
//  ConnectionCompleteView.swift
//  Presentation
//
//  Created by 박서연 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import DesignSystem

@ViewAction(for: ConnectionCompleteFeature.self)
public struct ConnectionCompleteView: View {
    
    public let store: StoreOf<ConnectionCompleteFeature>
    
    public init(store: StoreOf<ConnectionCompleteFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Image(.imgConnectionCompleteBackground)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                
                VStack {
                    Spacer()
                    
                    Header()
                    
                    Spacer()
                    
                    Image(.imgBoom)
                    TBottomButton(title: "다음", isEnable: true) {
                        send(.tappedNextButton)
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
    
    @ViewBuilder
    private func Header() -> some View {
        Text("김회원 트레이니와\n연결되었어요!")
            .typographyStyle(.heading1, with: .common0)
            .multilineTextAlignment(.center)
        
        HStack(spacing: 16) {
            userProfileView(imgae: .imgOnboardingTrainee, name: "김회원")
            userProfileView(imgae: .imgOnboardingTrainer, name: "김피티")
        }
    }
    
    @ViewBuilder
    private func userProfileView(imgae: ImageResource, name: String) -> some View {
        VStack(spacing: 12) {
            Image(imgae)
                .resizable()
                .frame(width: 100, height: 100)
                .scaledToFill()
                .clipShape(Circle())
            
            Text(name)
                .typographyStyle(.body2Medium, with: .neutral300)
                .frame(maxWidth: .infinity)
        }
        .frame(width: 100)
    }
}

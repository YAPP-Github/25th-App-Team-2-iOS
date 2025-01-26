//
//  ConnectedTraineeProfileView.swift
//  Presentation
//
//  Created by 박서연 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

public struct ConnectedTraineeProfileView: View {
    public let store: StoreOf<ConnectedTraineeProfileFeature>
    
    public init(store: StoreOf<ConnectedTraineeProfileFeature>) {
        self.store = store
    }
    
    private enum Info: String {
        case goal = "PT 목표"
        case caution = "주의사항"
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
                    
                    traineeView()
                    
                    Spacer()
                   
                    TBottomButton(title: "시작하기", state: .true) {
                        store.send(.view(.startButtonTapped))
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationBarBackButtonHidden()
        }
        .background(Color.neutral800)
    }
    
    @ViewBuilder
    private func traineeView() -> some View {
        VStack(spacing: 16) {
            Text("함께할 트레이니는 이런 분이에요!")
                .typographyStyle(.heading4, with: .common0)
                .frame(maxWidth: .infinity)
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.common0)
                .overlay {
                    VStack {
                        VStack(spacing: 10) {
                            Image(.imgOnboardingTrainee)
                                .resizable()
                                .frame(width: 128, height: 128)
                                .clipShape(Circle())
                            
                            HStack(spacing: 4) {
                                Text("김회원")
                                    .typographyStyle(.heading2, with: .neutral950)
                                Text("트레이니")
                                    .typographyStyle(.heading4, with: .neutral950)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 24) {
                            HStack(spacing: 21) {
                                traineeProfileView(title: "나이", content: "24세")
                                traineeProfileView(title: "키", content: "165")
                                traineeProfileView(title: "체중", content: "52kg")
                            }
                            
                            traineeInfoView(content: "contentententne", type: .goal)
                            traineeInfoView(content: "catoutoingldsjl", type: .caution)
                        }
                    }
                    .padding(.init(top: 32, leading: 20, bottom: 32, trailing: 20))
                }
                .frame(height: 581)
                .padding(.horizontal, 40)
        }
    }
    
    @ViewBuilder
    private func traineeProfileView(title: String, content: String) -> some View {
        HStack(spacing: 12) {
            Text(title)
                .typographyStyle(.body2Bold, with: .neutral950)
            Text(content)
                .typographyStyle(.body2Medium, with: .neutral500)
        }
    }
    
    @ViewBuilder
    private func traineeInfoView(content: String, type: Info) -> some View {
        VStack(spacing: 7) {
            Text(type.rawValue)
                .typographyStyle(.body1Bold, with: .neutral900)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(content)
                .typographyStyle(.label1Medium, with: .neutral800)
                .frame(height: type == .caution ? 128 : nil)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.init(top: 10, leading: 16, bottom: 10, trailing: 16))
                .background(Color.neutral100)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

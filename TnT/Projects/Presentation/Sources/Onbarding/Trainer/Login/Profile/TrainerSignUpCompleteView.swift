//
//  TrainerProfileCompleteView.swift
//  Presentation
//
//  Created by 박서연 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

public struct TrainerSignUpCompleteView: View {
    public let store: StoreOf<TrainerSignUpCompleteFeature>
    
    public init(store: StoreOf<TrainerSignUpCompleteFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                Spacer().frame(height: 80.5)
                
                Text("만나서 반가워요\n김헬짱 트레이너님!")
                    .typographyStyle(.heading1, with: .neutral950)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Text("트레이니와 함께\n케미를 터뜨려보세요! 🧨")
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height: 18)
                
                Image(.imgDefaultProfileImage)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                
                Spacer()
                
                TBottomButton(title: "시작하기", state: .true) {
                    store.send(.view(.startButtonTapped))
                }
            }
            .navigationBarBackButtonHidden()
            .navigationDestination(
                isPresented: Binding(get: { store.viewState.isNavigating }, set: { store.send(.setNavigating($0))})
            ) {
                
            }
        }
    }
}

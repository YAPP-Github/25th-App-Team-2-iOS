//
//  TraineeInfoInputCompletionView.swift
//  Presentation
//
//  Created by 박민서 on 1/26/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import Domain
import DesignSystem

/// 회원가입 완료 후 프로필 정보를 표시하는 화면
/// - 사용자 타입 및 이름을 표시
/// - 상대 유저 타입을 안내하는 메시지 제공
/// - "시작하기" 버튼을 통해 다음 화면으로 이동
@ViewAction(for: TraineeProfileCompletionFeature.self)
public struct TraineeProfileCompletionView: View {
    
    @Bindable public var store: StoreOf<TraineeProfileCompletionFeature>
    
    /// `ProfileCompletion` 생성자
    /// - Parameter store: `TraineeProfileCompletionFeature`와 연결된 Store
    public init(store: StoreOf<TraineeProfileCompletionFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 28) {
                Header()
                ImageSection()
            }
            .padding(.top, 100)

            Spacer()
        }
        .navigationBarBackButtonHidden()
        .keyboardDismissOnTap()
        .safeAreaInset(edge: .bottom) {
            TBottomButton(
                title: "시작하기",
                isEnable: true
            ) {
                send(.tapNextButton)
            }
        }
    }

    // MARK: - Sections
    @ViewBuilder
    private func Header() -> some View {
        VStack(spacing: 10) {
            Text("만나서 반가워요\n\(store.userName) \(store.userType.koreanName)님!")
                .typographyStyle(.heading1, with: .neutral950)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Text("\(store.view_opponentUserType.koreanName)와 함께\n케미를 터뜨려보세요! 🧨")
                .typographyStyle(.body1Medium, with: .neutral500)
                .multilineTextAlignment(.center)
        }
    }

    @ViewBuilder
    private func ImageSection() -> some View {
        Image(.imgDefaultTraineeImage)
            .resizable()
            .frame(width: 200, height: 200)
            .clipShape(Circle())
    }
    
    @ViewBuilder
    public func ImageSection(imgURL: URL) -> some View {
        if let urlString = store.profileImage, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .tint(.red500)
                        .frame(width: 132, height: 132)
                    
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 132, height: 132)
                        .clipShape(Circle())
                    
                case .failure:
                    Image(store.userType == .trainee ? .imgDefaultTraineeImage : .imgDefaultTrainerImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 132, height: 132)
                        .clipShape(Circle())
                    
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image(store.userType == .trainee ? .imgDefaultTraineeImage : .imgDefaultTrainerImage)
                .resizable()
                .scaledToFill()
                .frame(width: 132, height: 132)
                .clipShape(Circle())
        }
    }
}

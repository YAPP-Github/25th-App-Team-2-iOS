//
//  TrainerManagementView.swift
//  Presentation
//
//  Created by 박서연 on 2/7/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import DesignSystem
import Domain

struct TrainerManagementView: View {
    
    public var store: StoreOf<TrainerManagementFeature>
    
    public init(store: StoreOf<TrainerManagementFeature>) {
        self.store = store
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                
                Header()
                if let trainees = store.traineeList {
                    TraineeListView(trainees: trainees)
                } else {
                    EmptyListView()
                        .frame(minHeight: UIScreen.main.bounds.height - 204)
                }
            }
            .onAppear {
                store.send(.view(.onappear))
            }
            .navigationBarBackButtonHidden()
        }
        .background(Color.neutral100)
    }
    
    @ViewBuilder
    func Header() -> some View {
        TNavigation(type: .LTextRButtonTitle(
            leftTitle: "내 회원",
            pointText: "\(store.traineeList?.count ?? 0)",
            rightButton: "회원 초대하기")
        )
        .rightTap {
            store.send(.view(.goTraineeInvitation))
        }
    }
    
    /// 연결된 회원이 있는 경우
    @ViewBuilder
    func TraineeListView(trainees: [ActiveTraineeInfoResEntity]) -> some View {
        VStack(spacing: 0) {
            ForEach(trainees, id: \.id) { trainee in
                ListCellView(trainee: trainee)
                    .padding(.bottom, 16)
            }
        }
    }
    
    /// 연결된 회원이 없는 경우
    @ViewBuilder
    func EmptyListView() -> some View {
        VStack(spacing: 4) {
            Spacer()
            Text("아직 연결된 회원이 없어요")
                .typographyStyle(.body2Bold, with: Color.neutral600)
            Text("추가 버튼을 눌러 회원을 추가해 보세요")
                .typographyStyle(.label1Medium, with: Color.neutral400)
            Spacer()
        }
    }
    
    @ViewBuilder
    func ListCellView(trainee: ActiveTraineeInfoResEntity) -> some View {
        VStack(spacing: 12) {
            HStack {
                HStack {
                    ProfileImageView(imageURL: trainee.profileImageUrl)
                    
                    VStack(spacing: 12) {
                        Text(trainee.name)
                            .typographyStyle(.body1Bold, with: Color.neutral900)
                        Text(trainee.ptGoals.joined(separator: ", "))
                            .typographyStyle(.label2Medium, with: Color.neutral500)
                    }
                }
                
                Spacer()
                TChip(leadingEmoji: "💪", title: "\(trainee.finishedPtCount)", style: .blue)
            }
            
            VStack(spacing: 5) {
                Text("메모")
                    .typographyStyle(.label2Bold, with: Color.neutral600)
                Text(trainee.memo)
                    .typographyStyle(.label2Medium, with: Color.neutral500)
            }
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

extension TrainerManagementView {
    struct ProfileImageView: View {
        let imageURL: String?
        
        var body: some View {
            if let urlString = imageURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .tint(.red500)
                            .frame(width: 60, height: 60)
                        
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                    case .failure:
                        Image(.imgDefaultTrainerImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(.imgDefaultTrainerImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 132, height: 132)
                    .clipShape(Circle())
            }
        }
    }
}

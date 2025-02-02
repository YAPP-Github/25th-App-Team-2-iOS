//
//  TWorkoutCard.swift
//  DesignSystem
//
//  Created by 박민서 on 2/2/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// 트레이니 - PT 운동 카드
public struct TWorkoutCard: View {
    private let chipUIInfo: TChip.UIInfo
    private let timeText: String
    private let title: String
    private let imgURL: URL?
    private let hasRecord: Bool
    private let footerTapAction: (() -> Void)?
    
    public init(
        chipUIInfo: TChip.UIInfo,
        timeText: String,
        title: String,
        imgURL: URL?,
        hasRecord: Bool,
        footerTapAction: (() -> Void)? = nil
    ) {
        self.chipUIInfo = chipUIInfo
        self.timeText = timeText
        self.title = title
        self.imgURL = imgURL
        self.hasRecord = hasRecord
        self.footerTapAction = footerTapAction
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Header()
            
            MainBody()
            
            if hasRecord {
                Footer()
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .background(Color.neutral100)
        .clipShape(.rect(cornerRadius: 12))
    }
    
    // MARK: Section
    @ViewBuilder
    public func Header() -> some View {
        HStack {
            TChip(uiInfo: chipUIInfo)
            Spacer()
            TimeIndicator(timeText: timeText)
        }
    }
    
    @ViewBuilder
    public func MainBody() -> some View {
        HStack(spacing: 6) {
            if let imgURL {
                TrainerImage(imgURL: imgURL)
            } else {
                Image(.imgDefaultTrainerImage)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .scaledToFill()
                    .clipShape(Circle())
            }
            
            Text(title)
                .typographyStyle(.body1Bold, with: .neutral800)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    public func Footer() -> some View {
        HStack {
            Button(action: {
                footerTapAction?()
            }, label: {
                HStack(spacing: 2) {
                    Image(.icnStarSmile)
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("수업 기록 보기")
                        .typographyStyle(.label2Medium)
                }
            })
            Spacer()
        }
    }
}

private extension TWorkoutCard {
    struct TrainerImage: View {
        let imgURL: URL
        
        init(imgURL: URL) {
            self.imgURL = imgURL
        }
        
        var body: some View {
            AsyncImage(url: imgURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .tint(.red500)
                        .frame(width: 24, height: 24)
                    
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                        .clipShape(Circle())
                    
                case .failure(let error):
                    Image(.imgDefaultTrainerImage)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .scaledToFill()
                        .clipShape(Circle())
                    
                @unknown default:
                    Image(.imgDefaultTrainerImage)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .scaledToFill()
                        .clipShape(Circle())
                }
            }
        }
    }
}

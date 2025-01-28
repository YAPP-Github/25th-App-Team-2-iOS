//
//  TRecordCard.swift
//  DesignSystem
//
//  Created by 박민서 on 1/29/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

public struct TRecordCard: View {
    private let chipUIInfo: TChip.UIInfo
    private let timeText: String
    private let title: String
    private let imgURL: URL?
    private let feedbackCount: Int?
    
    public init(
        chipUIInfo: TChip.UIInfo,
        timeText: String,
        title: String,
        imgURL: URL?,
        feedbackCount: Int?
    ) {
        self.chipUIInfo = chipUIInfo
        self.timeText = timeText
        self.title = title
        self.imgURL = imgURL
        self.feedbackCount = feedbackCount
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                if let imgURL {
                    ImageSection(imgURL: imgURL)
                        
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Header()
                    Text(title)
                        .typographyStyle(.body1Bold, with: .neutral800)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, imgURL == nil ? 20 : 16)
            }
            
            if let feedbackCount {
                Footer(feedbackCount: feedbackCount)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
            }
        }
    }
    
    // MARK: Section
    @ViewBuilder
    public func ImageSection(imgURL: URL) -> some View {
        AsyncImage(url: imgURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .tint(.red500)
                    .frame(width: 140, height: 140)
                    .padding(.leading, 12)
                    .padding(.vertical, 12)
                
            case .success(let image):
                image
                    .resizable()
                    .frame(width: 140, height: 140)
                    .scaledToFill()
                    .clipShape(.rect(cornerRadius: 16))
                    .padding(.leading, 12)
                    .padding(.vertical, 12)
                
            case .failure(let error):
                EmptyView()
                
            @unknown default:
                EmptyView()
            }
        }
    }
    
    @ViewBuilder
    public func Header() -> some View {
        HStack {
            TChip(uiInfo: chipUIInfo)
            Spacer()
            TimeIndicator(timeText: timeText)
        }
    }
    
    @ViewBuilder
    public func Footer(feedbackCount: Int) -> some View {
        HStack {
            HStack(spacing: 2) {
                Image(.icnStarSmile)
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("받은 피드백")
                    .typographyStyle(.label2Medium)
                Text("\(feedbackCount)")
                    .typographyStyle(.label2Bold, with: .neutral500)
            }
            Spacer()
        }
    }
}

private extension TRecordCard {
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
}

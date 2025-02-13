//
//  TRecordCard.swift
//  DesignSystem
//
//  Created by 박민서 on 1/29/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// 트레이니 - 운동/식단 카드
public struct TRecordCard: View {
    private let chipUIInfo: TChip.UIInfo?
    private let timeText: String
    private let title: String
    private let imgURL: URL?
    private let hasFeedback: Bool
    private let footerTapAction: (() -> Void)?
    
    public init(
        chipUIInfo: TChip.UIInfo?,
        timeText: String,
        title: String,
        imgURL: URL?,
        hasFeedback: Bool,
        footerTapAction: (() -> Void)?
    ) {
        self.chipUIInfo = chipUIInfo
        self.timeText = timeText
        self.title = title
        self.imgURL = imgURL
        self.hasFeedback = hasFeedback
        self.footerTapAction = footerTapAction
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
                        .lineLimit(imgURL == nil ? 3 : 2)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, imgURL == nil ? 20 : 16)
            }
            
            if hasFeedback {
                Footer()
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
            }
        }
        .background(Color.common0)
        .clipShape(.rect(cornerRadius: 12))
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
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 140)
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
            if let chipUIInfo {
                TChip(uiInfo: chipUIInfo)
            }
            Spacer()
            TimeIndicator(timeText: timeText)
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
                    Text("받은 피드백")
                        .typographyStyle(.label2Medium)
                }
            })
            Spacer()
        }
    }
}

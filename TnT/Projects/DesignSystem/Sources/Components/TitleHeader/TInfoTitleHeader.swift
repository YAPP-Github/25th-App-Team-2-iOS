//
//  InfoTitleHeader.swift
//  DesignSystem
//
//  Created by 박민서 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// TnT 앱 내에서 정보 표시 관련된 화면에 사용되는 헤더 컴포넌트입니다.
/// 화면 상단에서 주요 제목(title)과 부제목(subTitle)을 표시하는 역할을 합니다.
public struct TInfoTitleHeader: View {
    /// 헤더의 제목
    private let title: String
    /// 헤더의 부제목 (옵션)
    private let subTitle: String?
    
    /// InfoTitleHeader 생성자
    /// - Parameters:
    ///   - title: 헤더의 주요 제목
    ///   - subTitle: 헤더의 부제목 (기본값: nil)
    public init(title: String, subTitle: String? = nil) {
        self.title = title
        self.subTitle = subTitle
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .typographyStyle(.heading2, with: .neutral950)
            
            if let subTitle {
                Text(subTitle)
                    .typographyStyle(.body1Medium, with: .neutral500)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
    }
}

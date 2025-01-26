//
//  TPageIndicator.swift
//  DesignSystem
//
//  Created by 박민서 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// 페이지 번호를 표시하는 UI 컴포넌트입니다.
/// 현재 페이지 여부에 따라 스타일이 변경됩니다.
public struct TPageIndicator: View {
    /// 표시할 페이지 번호
    private let pageNumber: Int
    /// 현재 선택된 페이지 여부
    private let isCurrent: Bool
    
    /// PageListItem 생성자
    /// - Parameters:
    ///   - pageNumber: 표시할 페이지 번호
    ///   - isCurrent: 현재 페이지 여부
    public init(pageNumber: Int, isCurrent: Bool) {
        self.pageNumber = pageNumber
        self.isCurrent = isCurrent
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .fill(isCurrent ? Color.common100 : Color.neutral200)
                .frame(width: 22, height: 22)
                .padding(4)
            
            Text("\(pageNumber)")
                .typographyStyle(.label2Medium, with: isCurrent ? Color.white : Color.neutral400)
        }
    }
}

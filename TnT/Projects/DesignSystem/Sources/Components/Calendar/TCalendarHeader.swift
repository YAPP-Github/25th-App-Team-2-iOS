//
//  TCalendarHeader.swift
//  DesignSystem
//
//  Created by 박민서 on 2/2/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// TCalendarView의 헤더입니다
/// 월 이동 로직을 추가합니다
public struct TCalendarHeader<RightView: View>: View {
    
    @Binding private var currentPage: Date
    private var formatter: (Date) -> String
    private var rightView: (() -> RightView)?
    
    public init(
        currentPage: Binding<Date>,
        formatter: @escaping (Date) -> String,
        rightView: (() -> RightView)? = nil
    ) {
        self._currentPage = currentPage
        self.formatter = formatter
        self.rightView = rightView
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                movePage(-1)
            }, label: {
                Image(.icnTriangleLeft32px)
                    .resizable()
                    .frame(width: 32, height: 32)
            })
            
            Text("\(formatter(currentPage))")
                .typographyStyle(.heading3, with: .neutral900)
            
            Button(action: {
                movePage(1)
            }, label: {
                Image(.icnTriangleRight32px)
                    .resizable()
                    .frame(width: 32, height: 32)
            })
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .trailing) {
            rightView?()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 20)
    }
    
    private func movePage(_ direction: Int) {
        if let nextPage = Calendar.current.date(byAdding: .month, value: direction, to: currentPage) {
            currentPage = nextPage
        }
    }
}

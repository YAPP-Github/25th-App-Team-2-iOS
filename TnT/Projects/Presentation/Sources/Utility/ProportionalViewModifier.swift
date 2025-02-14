//
//  ProportionalFrameModifier.swift
//  Presentation
//
//  Created by 박민서 on 2/14/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

public struct ProportionalFrameModifier: ViewModifier {
    /// 전체 화면 너비 대비 비율 (예: 0.25 -> 25%)
    let widthRatio: CGFloat?
    /// 전체 화면 높이 대비 비율 (예: 0.25 -> 25%)
    let heightRatio: CGFloat?

    public func body(content: Content) -> some View {
        content
            .frame(
                width: widthRatio.map { UIScreen.main.bounds.width * $0 },
                height: heightRatio.map { UIScreen.main.bounds.height * $0 }
            )
    }
}

public extension View {
    func frame(widthRatio: CGFloat? = nil, heightRatio: CGFloat? = nil) -> some View {
        self.modifier(ProportionalFrameModifier(widthRatio: widthRatio, heightRatio: heightRatio))
    }
}

public struct ProportionalPaddingModifier: ViewModifier {
    
    let topRatio: CGFloat?
    let leadingRatio: CGFloat?
    let trailingRatio: CGFloat?
    let bottomRatio: CGFloat?
    
    public func body(content: Content) -> some View {
        content
            .padding(
                EdgeInsets(
                    top: topRatio.map { UIScreen.main.bounds.height * $0 } ?? 0,
                    leading: leadingRatio.map { UIScreen.main.bounds.width * $0 } ?? 0,
                    bottom: bottomRatio.map { UIScreen.main.bounds.height * $0 } ?? 0,
                    trailing: trailingRatio.map { UIScreen.main.bounds.width * $0 } ?? 0
                )
            )
    }
}

public extension View {
    /// 개별적으로 top, leading, trailing, bottom을 설정하는 비율 패딩
    func padding(
        topRatio: CGFloat? = nil,
        leadingRatio: CGFloat? = nil,
        trailingRatio: CGFloat? = nil,
        bottomRatio: CGFloat? = nil
    ) -> some View {
        self.modifier(ProportionalPaddingModifier(
            topRatio: topRatio,
            leadingRatio: leadingRatio,
            trailingRatio: trailingRatio,
            bottomRatio: bottomRatio
        ))
    }
    
    /// 수평(leading, trailing) 패딩 비율 설정
    func padding(horizontalRatio: CGFloat) -> some View {
        self.padding(leadingRatio: horizontalRatio, trailingRatio: horizontalRatio)
    }
    
    /// 수직(top, bottom) 패딩 비율 설정
    func padding(verticalRatio: CGFloat) -> some View {
        self.padding(topRatio: verticalRatio, bottomRatio: verticalRatio)
    }
}

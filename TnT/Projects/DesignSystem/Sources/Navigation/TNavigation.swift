//
//  TNavigation.swift
//  DesignSystem
//
//  Created by 박서연 on 1/15/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// TnT 앱 내에서 사용되는 네비게이션 컴포넌트입니다
public struct TNavigation: View {
    /// 네비게이션 타입을 정의하는 열거형 (`TNavigationCase`)
    public let type: TNavigationCase
    /// 왼쪽 버튼 동작 (옵셔널)
    public var leftAction: (() -> Void)?
    /// 오른쪽 버튼 동작 (옵셔널)
    public var rightAction: (() -> Void)?
    
    /// TNavigation 초기화 메서드
    /// - Parameters:
    ///   - type: 네비게이션 바의 유형 (`TNavigationCase`)
    ///   - leftAction: 왼쪽 버튼 탭 동작 (옵셔널)
    ///   - rightAction: 오른쪽 버튼 탭 동작 (옵셔널)
    public init(
        type: TNavigationCase,
        leftAction: (() -> Void)? = nil,
        rightAction: (() -> Void)? = nil
    ) {
        self.type = type
        self.leftAction = leftAction
        self.rightAction = rightAction
    }
    
    public var body: some View {
        HStack {
            // 왼쪽 뷰
            leftView
            Spacer()
            // 중앙 타이틀
            centerTitle
            Spacer()
            // 오른쪽 뷰
            rightView
        }
        .padding(.init(top: 14, leading: 16, bottom: 14, trailing: 16))
    }
    
    @ViewBuilder
    private var leftView: some View {
        switch type {
        case .LButtonWithTitle(let leftImage, _),
                .LRButtonWithTitle(let leftImage, _, _),
                .LButtonRTextWithTitle(let leftImage, _, _),
                .LButton(leftImage: let leftImage):
            Image(leftImage)
                .resizable()
                .frame(width: 32, height: 32)
                .onTapGesture {
                    leftAction?()
                }
            
        case .Title, .RTextWithTitle:
            Rectangle()
                .fill(Color.clear)
                .frame(width: 32, height: 32)
        }
    }
    
    @ViewBuilder
    private var centerTitle: some View {
        switch type {
        case .LButtonWithTitle(_, let centerTitle),
                .LRButtonWithTitle(_, let centerTitle, _),
                .LButtonRTextWithTitle(_, let centerTitle, _),
                .RTextWithTitle(let centerTitle, _),
                .Title(let centerTitle):
            Text(centerTitle)
                .typographyStyle(.heading4, with: .neutral900)
                .frame(maxWidth: .infinity, alignment: .center)
        case .LButton:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var rightView: some View {
        switch type {
        case .LRButtonWithTitle(_, _, let rightImage):
            Image(rightImage)
                .resizable()
                .frame(width: 32, height: 32)
                .onTapGesture {
                    rightAction?()
                }
            
        case .LButtonRTextWithTitle(_, _, let rightText), .RTextWithTitle(_, let rightText):
            Text(rightText)
                .typographyStyle(.body2Medium, with: .neutral400)
                .onTapGesture {
                    rightAction?()
                }
            
        case .LButtonWithTitle, .Title, .LButton:
            Rectangle()
                .fill(Color.clear)
                .frame(width: 32, height: 32)
        }
    }
}

public extension TNavigation {
    /// 왼쪽 버튼 동작을 설정하는 메서드
    /// - Parameter leftAction: 실행할 동작
    /// - Returns: 업데이트된 TNavigation
    func leftTap(leftAction: @escaping (() -> Void)) -> Self {
        var copy: Self = self
        copy.leftAction = leftAction
        return copy
    }
    
    /// 오른쪽 버튼 동작을 설정하는 메서드
    /// - Parameter rightAction: 실행할 동작
    /// - Returns: 업데이트된 TNavigation
    func rightTap(rightAction: @escaping (() -> Void)) -> Self {
        var copy: Self = self
        copy.rightAction = rightAction
        return copy
    }
}

/// 네비게이션 바의 유형을 정의하는 열거형
public enum TNavigationCase {
    /// 왼쪽 이미지 버튼, 센터 타이틀
    case LButtonWithTitle(leftImage: ImageResource, centerTitle: String)
    /// 왼쪽 이미지 버튼, 센터 타이틀, 오른쪽 이미지 버튼
    case LRButtonWithTitle(leftImage: ImageResource, centerTitle: String, rightImage: ImageResource)
    /// 왼쪽 이미지 버튼, 센터 타이틀, 오른쪽 텍스트 버튼
    case LButtonRTextWithTitle(leftImage: ImageResource, centerTitle: String, rightText: String)
    /// 오른쪽 텍스트 버튼, 센터 타이틀
    case RTextWithTitle(centerTitle: String, rightText: String)
    /// 타이틀
    case Title(centerTitle: String)
    /// 왼쪽 이미지
    case LButton(leftImage: ImageResource)
}

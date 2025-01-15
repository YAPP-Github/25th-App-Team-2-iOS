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
        switch type {
            /// 왼쪽 이미지 버튼, 센터 타이틀
        case .LButtonWithTitle(let imageResource, let title):
            HStack {
                Text(title)
                    .typographyStyle(.heading4, with: .neutral900)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .overlay(alignment: .topLeading) {
                        Image(imageResource)
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                    .onTapGesture {
                        leftAction?()
                    }
            }
            .padding(.init(top: 22.5, leading: 20, bottom: 10.5, trailing: 20))
            
            /// 왼쪽 이미지 버튼, 센터 타이틀, 오른쪽 이미지 버튼
        case .LRButtonWithTitle(let LImage, let title, let RImage):
            HStack {
                Image(LImage)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .onTapGesture {
                        leftAction?()
                    }
                
                Text(title)
                    .typographyStyle(.heading4, with: .neutral900)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Image(RImage)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .onTapGesture {
                        rightAction?()
                    }
            }
            .padding(.init(top: 22.5, leading: 20, bottom: 10.5, trailing: 20))
            
            /// 왼쪽 이미지 버튼, 센터 타이틀, 오른쪽 텍스트 버튼
        case .LButtonRTextWithTitle(let LImage, let title, let RText):
            HStack {
                Image(LImage)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .onTapGesture {
                        leftAction?()
                    }
                
                Text(title)
                    .typographyStyle(.heading4, with: .neutral900)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text(RText)
                    .typographyStyle(.body2Medium, with: .neutral400)
                    .onTapGesture {
                        rightAction?()
                    }
            }
            .padding(.init(top: 22.5, leading: 20, bottom: 10.5, trailing: 20))
            
            /// 타이틀
        case .Title(let title):
            Text(title)
                .typographyStyle(.heading4, with: .neutral900)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.init(top: 22.5, leading: 20, bottom: 10.5, trailing: 20))
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
    case LButtonWithTitle(ImageResource, String)
    /// 왼쪽 이미지 버튼, 센터 타이틀, 오른쪽 이미지 버튼
    case LRButtonWithTitle(ImageResource, String, ImageResource)
    /// 왼쪽 이미지 버튼, 센터 타이틀, 오른쪽 텍스트 버튼
    case LButtonRTextWithTitle(ImageResource, String, String)
    /// 타이틀
    case Title(String)
}

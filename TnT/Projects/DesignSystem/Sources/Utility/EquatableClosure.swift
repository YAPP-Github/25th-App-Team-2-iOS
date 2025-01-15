//
//  EquatableClosure.swift
//  DesignSystem
//
//  Created by 박민서 on 1/16/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 클로저를 Equatable로 사용할 수 있도록 래핑한 구조체입니다.
/// 고유 ID를 통해 클로저의 동등성을 비교하며, 내부에서 클로저를 실행할 수 있는 기능을 제공합니다.
public struct EquatableClosure: Equatable {
    /// EquatableClosure를 고유하게 식별할 수 있는 UUID입니다.
    private let id: UUID = UUID()
    /// 실행할 클로저
    private let action: () -> Void
    
    public static func == (lhs: EquatableClosure, rhs: EquatableClosure) -> Bool {
        lhs.id == rhs.id
    }
    
    /// EquatableClosure 초기화 메서드
    /// - Parameter action: 실행할 클로저
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    /// 클로저를 실행하는 메서드
    public func execute() {
        action()
    }
}

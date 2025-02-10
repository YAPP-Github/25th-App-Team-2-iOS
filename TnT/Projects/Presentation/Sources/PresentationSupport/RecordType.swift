//
//  RecordType.swift
//  Presentation
//
//  Created by 박민서 on 1/29/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Domain
import DesignSystem

extension RecordType {
    /// 앱에서 사용되는 Chip에 연결되는 색상 스타일 입니다
    var chipStyle: TChip.Style {
        switch self {
        case .session, .workout:
            return .blue
        case .diet:
            return .pink
        }
    }
    
    /// 해당 기록을 표시하는 이모지 입니다
    var emoji: String? {
        switch self {
        case .session(let count):
            return "💪"
        case .workout:
            return nil
        case .diet(let type):
            return type.emoji
        }
    }
    
    /// 앱에서 사용되는 Chip에 연결되는 전체 UI 정보 입니다
    var chipInfo: TChip.UIInfo {
        return .init(leadingEmoji: self.emoji, title: self.koreanName, style: self.chipStyle)
    }
}

//
//  GetTheFirstInvitationCodeDTO.swift
//  Domain
//
//  Created by 박서연 on 2/4/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 트레이너의 최초 연결 코드
public struct GetTheFirstInvitationCodeDTO: Decodable {
    public let invitationCode: String
    
    public init(invitationCode: String) {
        self.invitationCode = invitationCode
    }
}

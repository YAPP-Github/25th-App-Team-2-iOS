//
//  GetReissuanceInvitationCodeDTO.swift
//  Domain
//
//  Created by 박서연 on 2/4/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

public struct GetReissuanceInvitationCodeDTO: Decodable {
    public let invitationCode: String
    
    public init(invitationCode: String) {
        self.invitationCode = invitationCode
    }
}

//
//  RequestDTO.swift
//  Data
//
//  Created by 박민서 on 1/22/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

// MARK: ReqDTO 정의
struct UserCreateRequestDTO: Encodable {
    let name: String
    let age: Int
}

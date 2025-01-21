//
//  ExampleResponseDTO.swift
//  Data
//
//  Created by 박민서 on 1/22/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

// MARK: - ResDTO 정의
struct CreateUserResponseDTO: Decodable {
    let id: Int
}

struct FetchUserDetailResponseDTO: Decodable {
    let id: Int
    let name: String
    let age: Int
}

struct FetchUsersResponseDTO: Decodable {
    let users: [UserDTO]
}

struct UserDTO: Codable {
    let id: Int
    let name: String
    let age: Int
}

struct UploadResponseDTO: Decodable {
    let success: Bool
    let message: String
}

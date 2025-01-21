//
//  NetworkExample.swift
//  Data
//
//  Created by 박민서 on 1/22/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

// MARK: - API 요청 실행 - UseCase
struct NetworkExample {
    private let networkService: NetworkService = NetworkService.shared

    /// 전체 사용자 리스트 가져오기
    func fetchUsers() async {
        let result: Result<[FetchUsersResponseDTO], NetworkError> = await networkService.request(
            ExampleAPI.getUsers,
            decodingType: [FetchUsersResponseDTO].self
        )
        
        switch result {
        case .success(let users):
            print("✅ 사용자 목록: \(users)")
        case .failure(let error):
            print("❌ 사용자 목록 불러오기 실패: \(error.localizedDescription)")
        }
    }
    
    /// 특정 사용자 상세 정보 가져오기
    func fetchUserDetail(userID: Int) async {
        let result: Result<FetchUserDetailResponseDTO, NetworkError> = await networkService.request(
            ExampleAPI.getUserDetail(id: userID),
            decodingType: FetchUserDetailResponseDTO.self
        )
        
        switch result {
        case .success(let user):
            print("✅ 사용자 상세 정보: \(user)")
        case .failure(let error):
            print("❌ 사용자 상세 정보 불러오기 실패: \(error.localizedDescription)")
        }
    }
    
    /// 새로운 사용자 생성하기
    func createUser(name: String, age: Int) async {
        let result: Result<CreateUserResponseDTO, NetworkError> = await networkService.request(
            ExampleAPI.createUser(reqDTO: UserCreateRequestDTO(name: name, age: age)),
            decodingType: CreateUserResponseDTO.self
        )
        
        switch result {
        case .success(let newUser):
            print("✅ 새 사용자 생성 완료: \(newUser)")
        case .failure(let error):
            print("❌ 사용자 생성 실패: \(error.localizedDescription)")
        }
    }
    
    /// 프로필 이미지 업로드
    func uploadProfileImage(userID: Int, imageData: Data) async {
        let result: Result<UploadResponseDTO, NetworkError> = await networkService.request(
            ExampleAPI.uploadProfileImage(userID: userID, imageData: imageData),
            decodingType: UploadResponseDTO.self
        )
        
        switch result {
        case .success(let response):
            print("✅ 프로필 업로드 성공: \(response)")
        case .failure(let error):
            print("❌ 프로필 업로드 실패: \(error.localizedDescription)")
        }
    }
}

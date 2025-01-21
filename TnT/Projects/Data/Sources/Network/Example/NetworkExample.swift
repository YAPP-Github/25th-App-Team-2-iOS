//
//  NetworkExample.swift
//  Data
//
//  Created by 박민서 on 1/22/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

// MARK: - API 정의 (TargetType 활용)
enum ExampleAPI {
    case getUsers
    case getUserDetail(id: Int)
    case createUser(reqDTO: UserCreateRequestDTO)
    case uploadProfileImage(userID: Int, imageData: Data)
}

// MARK: ReqDTO 정의
struct UserCreateRequestDTO: Encodable {
    let name: String
    let age: Int
}

// MARK: - ExampleAPI의 TargetType 구현
extension ExampleAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.example.com")!
    }

    var path: String {
        switch self {
        case .getUsers:
            return "/users"
        case .getUserDetail(let id):
            return "/users/\(id)"
        case .createUser:
            return "/users"
        case .uploadProfileImage(let userID, _):
            return "/users/\(userID)/upload"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getUsers, .getUserDetail:
            return .get
        case .createUser:
            return .post
        case .uploadProfileImage:
            return .post
        }
    }

    var task: RequestTask {
        switch self {
        case .getUsers, .getUserDetail:
            return .requestPlain
            
        case .createUser(let dto):
            return .requestJSONEncodable(encodable: dto)
            
        case .uploadProfileImage(_, let imageData):
            return .uploadMultipart(
                files: [("profile", "profile.jpg", "image/jpeg", imageData)],
                additionalFields: [:]
            )
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var interceptors: [any Interceptor] {
        return [
            LoggingInterceptor(),
            AuthTokenInterceptor(),
            RetryInterceptor(maxRetryCount: 5)
        ]
    }
}

// MARK: - API 요청 실행
struct NetworkExample {
    private let networkService = NetworkService()

    /// 전체 사용자 리스트 가져오기
    func fetchUsers() async {
        let result: Result<[User], NetworkError> = await networkService.request(ExampleAPI.getUsers, decodingType: [User].self)
        
        switch result {
        case .success(let users):
            print("✅ 사용자 목록: \(users)")
        case .failure(let error):
            print("❌ 사용자 목록 불러오기 실패: \(error.localizedDescription)")
        }
    }
    
    /// 특정 사용자 상세 정보 가져오기
    func fetchUserDetail(userID: Int) async {
        let result: Result<User, NetworkError> = await networkService.request(ExampleAPI.getUserDetail(id: userID), decodingType: User.self)
        
        switch result {
        case .success(let user):
            print("✅ 사용자 상세 정보: \(user)")
        case .failure(let error):
            print("❌ 사용자 상세 정보 불러오기 실패: \(error.localizedDescription)")
        }
    }
    
    /// 새로운 사용자 생성하기
    func createUser(name: String, age: Int) async {
        let result: Result<User, NetworkError> = await networkService.request(
            ExampleAPI.createUser(reqDTO: UserCreateRequestDTO(name: name, age: age)),
            decodingType: User.self
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
        let result: Result<UploadResponse, NetworkError> = await networkService.request(ExampleAPI.uploadProfileImage(userID: userID, imageData: imageData), decodingType: UploadResponse.self)
        
        switch result {
        case .success(let response):
            print("✅ 프로필 업로드 성공: \(response)")
        case .failure(let error):
            print("❌ 프로필 업로드 실패: \(error.localizedDescription)")
        }
    }
}

// MARK: - 데이터 모델 정의
struct User: Codable {
    let id: Int
    let name: String
    let age: Int
}

struct UploadResponse: Codable {
    let success: Bool
    let message: String
}

// MARK: - 테스트 실행
@main
struct AppMain {
    static func main() async {
        Task {
            let example = NetworkExample()

            await example.fetchUsers()
            await example.fetchUserDetail(userID: 1)
            await example.createUser(name: "Minseo", age: 25)
            
            // 예제 이미지 데이터 생성
            let sampleImageData = Data(repeating: 0, count: 1024) // 임시 데이터
            await example.uploadProfileImage(userID: 1, imageData: sampleImageData)
        }
    }
}

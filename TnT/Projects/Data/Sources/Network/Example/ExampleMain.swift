//
//  ExampleMain.swift
//  Data
//
//  Created by 박민서 on 1/22/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

// MARK: - 테스트 실행
// @main
struct AppMain {
    static func main() async {
        Task {
            let example: NetworkExample = NetworkExample()

            await example.fetchUsers()
            await example.fetchUserDetail(userID: 1)
            await example.createUser(name: "Minseo", age: 25)
            
            // 예제 이미지 데이터 생성
            let sampleImageData: Data = Data(repeating: 0, count: 1024) // 임시 데이터
            await example.uploadProfileImage(userID: 1, imageData: sampleImageData)
        }
    }
}

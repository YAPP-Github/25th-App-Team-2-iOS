//
//  UserSignUpInfoEntity.swift
//  Domain
//
//  Created by 박민서 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 회원 가입 시 입력되는 기본 정보 구조체
public struct UserSignUpInfoEntity: Equatable {
    /// 사용자 유형 (트레이너 / 트레이니)
    public var userType: UserType
    /// 프로필 이미지 (옵션)
    public var profileImage: Data?
    /// 사용자 이름
    public var name: String
    /// 생년월일 (옵션)
    public var birthDate: Date?
    /// 키 (옵션, 단위: cm)
    public var height: Int?
    /// 몸무게 (옵션, 단위: kg, 소수점 가능)
    public var weight: Float?
    /// 운동 목적 (필수값)
    public var trainingPurpose: TrainingPurpose?
    /// 주의사항 (옵션, 사용자가 입력 가능)
    public var precaution: String?
    
    /// `UserSignUpInfo`의 생성자
    /// - Parameters:
    ///   - userType: 사용자 유형
    ///   - profileImage: 프로필 이미지 (기본값: `nil`)
    ///   - name: 사용자 이름
    ///   - birthDate: 생년월일 (기본값: `nil`)
    ///   - height: 키 (기본값: `nil`)
    ///   - weight: 몸무게 (기본값: `nil`)
    ///   - trainingPurpose: 운동 목적
    ///   - precaution: 주의사항 (기본값: `nil`)
    public init(
        userType: UserType,
        profileImage: Data? = nil,
        name: String,
        birthDate: Date? = nil,
        height: Int? = nil,
        weight: Float? = nil,
        trainingPurpose: TrainingPurpose,
        precaution: String? = nil
    ) {
        self.userType = userType
        self.profileImage = profileImage
        self.name = name
        self.birthDate = birthDate
        self.height = height
        self.weight = weight
        self.trainingPurpose = trainingPurpose
        self.precaution = precaution
    }
}

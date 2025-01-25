//
//  UserUseCase.swift
//  Domain
//
//  Created by 박민서 on 1/25/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Dependencies

// MARK: - UserUseCase 프로토콜
public protocol UserUseCase {    
    /// 개별 필드 - 생년월일 검증
    func validateBirthDate(_ birthDate: String) -> Bool
    /// 개별 필드 - 키 검증
    func validateHeight(_ height: String) -> Bool
    /// 개별 필드 - 몸무게 검증
    func validateWeight(_ weight: String) -> Bool
}

// MARK: - Default 구현체
public struct DefaultUserUseCase: UserUseCase {
    public init() {}

    /// 생년월일 검증
    public func validateBirthDate(_ birthDate: String) -> Bool {
        return birthDate.isEmpty || UserPolicy.birthDateInput.textValidation(birthDate)
    }

    /// 키 검증
    public func validateHeight(_ height: String) -> Bool {
        return !height.isEmpty && UserPolicy.heightInput.textValidation(height)
    }

    /// 몸무게 검증
    public func validateWeight(_ weight: String) -> Bool {
        return !weight.isEmpty && UserPolicy.weightInput.textValidation(weight)
    }
}

// MARK: - Swift-Dependencies
private enum UserUseCaseKey: DependencyKey {
    static let liveValue: UserUseCase = DefaultUserUseCase()
}

// MARK: - DependencyValues
public extension DependencyValues {
    var userUseCase: UserUseCase {
        get { self[UserUseCaseKey.self] }
        set { self[UserUseCaseKey.self] = newValue }
    }
}

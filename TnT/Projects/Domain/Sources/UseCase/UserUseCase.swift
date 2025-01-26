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
    /// 개별 필드 - 사용자 이름 검증
    func validateUserName(_ name: String) -> Bool
    /// 개별 필드 - 생년월일 검증
    func validateBirthDate(_ birthDate: String) -> Bool
    /// 개별 필드 - 키 검증
    func validateHeight(_ height: String) -> Bool
    /// 개별 필드 - 몸무게 검증
    func validateWeight(_ weight: String) -> Bool
    /// 개별 필드 - 주의사항 검증
    func validatePrecaution(_ text: String) -> Bool
    /// 초대 코드 검증
    func validateInvitationCode(_ code: String) -> Bool
    /// 이름 최대 길이 제한
    func getMaxNameLength() -> Int
    /// 주의사항 최대 길이 제한
    func getPrecautionMaxLength() -> Int
    // MARK: API Call
    /// API Call - 트레이너 초대 코드 인증 API 호출
    func verifyTrainerInvitationCode(_ code: String) async throws -> Bool
}

// MARK: - Default 구현체
public struct DefaultUserUseCase: UserUseCase {
    public init() {}
    
    public func validateUserName(_ name: String) -> Bool {
        return !name.isEmpty && UserPolicy.userNameInput.textValidation(name)
    }
    
    public func validateBirthDate(_ birthDate: String) -> Bool {
        return birthDate.isEmpty || UserPolicy.birthDateInput.textValidation(birthDate)
    }
    
    public func validateHeight(_ height: String) -> Bool {
        return !height.isEmpty && UserPolicy.heightInput.textValidation(height)
    }
    
    public func validateWeight(_ weight: String) -> Bool {
        return !weight.isEmpty && UserPolicy.weightInput.textValidation(weight)
    }
    
    public func validatePrecaution(_ text: String) -> Bool {
        return UserPolicy.precautionInput.textValidation(text)
    }
    
    public func validateInvitationCode(_ code: String) -> Bool {
        return !code.isEmpty && UserPolicy.invitationInput.textValidation(code)
    }
    
    public func getMaxNameLength() -> Int {
        return UserPolicy.maxNameLength
    }
    
    public func getPrecautionMaxLength() -> Int {
        return UserPolicy.maxPrecautionLength
    }
    
    public func verifyTrainerInvitationCode(_ code: String) async throws -> Bool {
        return Bool.random()
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

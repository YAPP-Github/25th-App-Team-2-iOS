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
    /// 이름 최대 길이 제한
    func getMaxNameLength() -> Int
    /// 주의사항 최대 길이 제한
    func getPrecautionMaxLength() -> Int
}

// MARK: - Default 구현체
public struct DefaultUserUseCase: UserUseCase {
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
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
    
    public func getMaxNameLength() -> Int {
        return UserPolicy.maxNameLength
    }
    
    public func getPrecautionMaxLength() -> Int {
        return UserPolicy.maxPrecautionLength
    }
}

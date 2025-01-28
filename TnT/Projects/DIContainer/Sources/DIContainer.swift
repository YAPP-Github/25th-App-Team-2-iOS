//
//  DIContainer.swift
//  DIContainer
//
//  Created by 박민서 on 1/27/25.
//

import Dependencies

import Domain
import Data

// MARK: - Swift-Dependencies
private enum UserUseCaseKey: DependencyKey {
    static let liveValue: UserUseCase = DefaultUserUseCase(userRepository: UserRepositoryImpl())
}

private enum TraineeUseCaseKey: DependencyKey {
    static let liveValue: TraineeUseCase = DefaultTraineeUseCase(trainerRepository: TrainerRepositoryImpl())
}

private enum SocialUseCaseKey: DependencyKey {
    static let liveValue: SocialLoginUserCase = DefaultSocialLoginUserCase(socialLoginRepository: SocialLogInRepositoryImpl())
}

// MARK: - DependencyValues
public extension DependencyValues {
    var userUseCase: UserUseCase {
        get { self[UserUseCaseKey.self] }
        set { self[UserUseCaseKey.self] = newValue }
    }
    
    var traineeUseCase: TraineeUseCase {
        get { self[TraineeUseCaseKey.self] }
        set { self[TraineeUseCaseKey.self] = newValue }
    }
    
    var socialLogInUseCase: SocialLoginUserCase {
        get { self[SocialUseCaseKey.self] }
        set { self[SocialUseCaseKey.self] = newValue }
    }
}

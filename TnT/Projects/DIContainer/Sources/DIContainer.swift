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
//    static let liveValue: UserUseCase
    static let liveValue: UserUseCase = DefaultUserUseCase(userRepostiory: UserRepositoryImpl())
}

private enum UserUseCaseRepoKey: DependencyKey {
    static let liveValue: UserRepository = DefaultUserUseCase(userRepostiory: UserRepositoryImpl())
}

private enum TraineeUseCaseKey: DependencyKey {
    static let liveValue: TraineeUseCase = DefaultTraineeUseCase(
        trainerRepository: TrainerRepositoryImpl(),
        traineeRepository: TraineeRepositoryImpl()
    )
}

private enum SocialUseCaseKey: DependencyKey {
    static let liveValue: SocialLoginUseCase = SocialLoginUseCase(socialLoginRepository: SocialLogInRepositoryImpl(loginManager: SNSLoginManager()))
}

private enum SocialUseCaseKey: DependencyKey {
    static let liveValue: SocialLoginUseCase = SocialLoginUseCase(socialLoginRepository: SocialLogInRepositoryImpl(loginManager: SNSLoginManager()))
}

// MARK: - DependencyValues
public extension DependencyValues {
    var userUseCase: UserUseCase {
        get { self[UserUseCaseKey.self] }
        set { self[UserUseCaseKey.self] = newValue }
    }
    
    var userUseRepoCase: UserRepository {
        get { self[UserUseCaseRepoKey.self] }
        set { self[UserUseCaseRepoKey.self] = newValue }
    }
    
    var traineeUseCase: TraineeUseCase {
        get { self[TraineeUseCaseKey.self] }
        set { self[TraineeUseCaseKey.self] = newValue }
    }
    
    var socialLogInUseCase: SocialLoginUseCase {
        get { self[SocialUseCaseKey.self] }
        set { self[SocialUseCaseKey.self] = newValue }
    }
}

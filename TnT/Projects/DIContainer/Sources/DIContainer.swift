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

private enum TraineeRepoUseCaseKey: DependencyKey {
    static let liveValue: TraineeRepository = DefaultTraineeUseCase(
        trainerRepository: TrainerRepositoryImpl(),
        traineeRepository: TraineeRepositoryImpl()
    )
}

private enum SocialUseCaseKey: DependencyKey {
    static let liveValue: SocialLoginUseCase = SocialLoginUseCase(socialLoginRepository: SocialLogInRepositoryImpl(loginManager: SNSLoginManager()))
}

private enum TrainerUseCaseRepoKey: DependencyKey {
    static let liveValue: TrainerRepository = DefaultTrainerUseCase(trainerRepository: TrainerRepositoryImpl())
}

private enum KeyChainManagerKey: DependencyKey {
    static let liveValue: KeyChainManager = keyChainManager
}

// MARK: - DependencyValues
public extension DependencyValues {
    var keyChainManager: KeyChainManager {
        get { self[KeyChainManagerKey.self] }
        set { self[KeyChainManagerKey.self] = newValue }
    }
    
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
    
    var traineeRepoUseCase: TraineeRepository {
        get { self[TraineeRepoUseCaseKey.self] }
        set { self[TraineeRepoUseCaseKey.self] = newValue }
    }
    
    var socialLogInUseCase: SocialLoginUseCase {
        get { self[SocialUseCaseKey.self] }
        set { self[SocialUseCaseKey.self] = newValue }
    }
    
    var trainerRepoUseCase: TrainerRepository {
        get { self[TrainerUseCaseRepoKey.self] }
        set { self[TrainerUseCaseRepoKey.self] = newValue }
    }
}

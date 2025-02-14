//
//  TrainerHomeResponseDTO.swift
//  Domain
//
//  Created by 박서연 on 2/4/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 특정 날짜의 PT 리스트 불러오기
public struct GetDateSessionListDTO: Decodable {
    public let count: Int
    public let date: String
    public let lessons: [SessonDTO]
    
    public init(
        count: Int,
        date: String,
        lessons: [SessonDTO]
    ) {
        self.count = count
        self.date = date
        self.lessons = lessons
    }
}

public struct SessonDTO: Decodable {
    public let ptLessonId: String
    public let traineeId: String
    public let traineeName: String
    public let traineeProfileImageUrl: String
    public let session: Int
    public let startTime: String
    public let endTime: String
    public let isCompleted: Bool
    
    public init(
        ptLessonId: String,
        traineeId: String,
        traineeName: String,
        traineeProfileImageUrl: String,
        session: Int,
        startTime: String,
        endTime: String,
        isCompleted: Bool
    ) {
        self.ptLessonId = ptLessonId
        self.traineeId = traineeId
        self.traineeName = traineeName
        self.traineeProfileImageUrl = traineeProfileImageUrl
        self.session = session
        self.startTime = startTime
        self.endTime = endTime
        self.isCompleted = isCompleted
    }
}

public struct GetDateSessionListEntity: Equatable, Encodable {
    public let id = UUID().uuidString
    public let count: Int
    public let date: String
    public let lessons: [SessonEntity]
    
    public init(
        count: Int,
        date: String,
        lessons: [SessonEntity]
    ) {
        self.count = count
        self.date = date
        self.lessons = lessons
    }
}

public struct SessonEntity: Equatable, Encodable {
    public let id = UUID().uuidString
    public let ptLessonId: String
    public let traineeId: String
    public let traineeName: String
    public let traineeProfileImageUrl: String
    public let session: Int
    public let startTime: String
    public let endTime: String
    public var isCompleted: Bool
    
    public init(
        ptLessonId: String,
        traineeId: String,
        traineeName: String,
        traineeProfileImageUrl: String,
        session: Int,
        startTime: String,
        endTime: String,
        isCompleted: Bool
    ) {
        self.ptLessonId = ptLessonId
        self.traineeId = traineeId
        self.traineeName = traineeName
        self.traineeProfileImageUrl = traineeProfileImageUrl
        self.session = session
        self.startTime = startTime
        self.endTime = endTime
        self.isCompleted = isCompleted
    }
}

// mapper
// MARK: - GetDateSessionListDTO -> GetDateSessionListEntity
public extension GetDateSessionListDTO {
    func toEntity() -> GetDateSessionListEntity {
        return GetDateSessionListEntity(
            count: self.count,
            date: self.date,
            lessons: self.lessons.map { $0.toEntity() }
        )
    }
    
    // GetDateSessionListEntity -> GetDateSessionListDTO
    func toDTO() -> GetDateSessionListDTO {
        return GetDateSessionListDTO(
            count: self.count,
            date: self.date,
            lessons: self.lessons.map { $0.toDTO() }
        )
    }
}

// MARK: - SessonDTO -> SessonEntity
public extension SessonDTO {
    func toEntity() -> SessonEntity {
        return SessonEntity(
            ptLessonId: self.ptLessonId,
            traineeId: self.traineeId,
            traineeName: self.traineeName,
            traineeProfileImageUrl: self.traineeProfileImageUrl,
            session: self.session,
            startTime: self.startTime.toDate(format: .ISO8601)?.toString(format: .a_HHmm) ?? "",
            endTime: self.endTime.toDate(format: .ISO8601)?.toString(format: .a_HHmm) ?? "",
            isCompleted: self.isCompleted
        )
    }
    
    // SessonEntity -> SessonDTO
    public func toDTO() -> SessonDTO {
        return SessonDTO(
            ptLessonId: self.ptLessonId,
            traineeId: self.traineeId,
            traineeName: self.traineeName,
            traineeProfileImageUrl: self.traineeProfileImageUrl,
            session: self.session,
            startTime: self.startTime,
            endTime: self.endTime,
            isCompleted: self.isCompleted
        )
    }
}

// MARK: - GetDateSessionListEntity -> GetDateSessionListDTO
public extension GetDateSessionListEntity {
    public func toDTO() -> GetDateSessionListDTO {
        return GetDateSessionListDTO(
            count: self.count,
            date: self.date,
            lessons: self.lessons.map { $0.toDTO() }
        )
    }
}

// MARK: - SessonEntity -> SessonDTO
public extension SessonEntity {
    public func toDTO() -> SessonDTO {
        return SessonDTO(
            ptLessonId: self.ptLessonId,
            traineeId: self.traineeId,
            traineeName: self.traineeName,
            traineeProfileImageUrl: self.traineeProfileImageUrl,
            session: self.session,
            startTime: self.startTime,
            endTime: self.endTime,
            isCompleted: self.isCompleted
        )
    }
}


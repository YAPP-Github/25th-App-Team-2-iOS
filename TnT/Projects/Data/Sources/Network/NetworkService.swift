//
//  NetworkService.swift
//  Data
//
//  Created by 박민서 on 1/21/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 10. NetworkService 구현 (URLSession 기반)
class NetworkService {
    private let session: URLSession
    private let tokenProvider: () -> String?
       
    init(session: URLSession = .shared, tokenProvider: @escaping () -> String?) {
        self.session = session
        self.tokenProvider = tokenProvider
    }
    
    func request<T: Decodable>(_ target: TargetType, decodingType: T.Type, forceRefresh: Bool = false) async -> Result<T, NetworkError> {
        let pipeline = InterceptorManager.shared.getPipeline(for: target)
        
        do {
            var request = try buildRequest(from: target)
            request = try await pipeline.adapt(request)
            let result = try await executeRequest(request, decodingType: decodingType, pipeline: pipeline)
            return .success(result)
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.unknown(statusCode: nil, message: error.localizedDescription))
        }
    }
    
    private func executeRequest<T: Decodable>(_ request: URLRequest, decodingType: T.Type, pipeline: InterceptorPipeline) async throws -> T {
        var attempt = 0
        let maxRetryCount = 5 // ✅ 무한 루프 방지
        
        while attempt < maxRetryCount {
            do {
                let (data, response) = try await session.data(for: request)
                try await pipeline.validate(response, data: data)
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                attempt += 1
                if !(try await pipeline.shouldRetry(request, dueTo: error, attempt: attempt)) {
                    throw error
                }
            }
        }
        
        throw NetworkError.unknown(statusCode: nil, message: "Max retry limit reached")
    }
    
    private func buildRequest(from target: TargetType) throws -> URLRequest {
        let url = target.baseURL.appendingPathComponent(target.path)
        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue
        return try target.task.configureURLRequest(request)
    }
}

//
//  DataSoureDummy.swift
//  Packages
//
//  Created by 박서연 on 1/4/25.
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
        let interceptors = InterceptorManager.shared.getInterceptors(for: target)
        let pipeline = InterceptorPipeline(interceptors: interceptors)
        
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
        while true {
            do {
                let (data, response) = try await session.data(for: request)
                try await pipeline.validate(response, data: data)
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                if !(try await pipeline.shouldRetry(request, dueTo: error, attempt: attempt)) {
                    throw error
                }
                attempt += 1
            }
        }
    }
    
    private func buildRequest(from target: TargetType) throws -> URLRequest {
        let url = target.baseURL.appendingPathComponent(target.path)
        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue
        return request
    }
}

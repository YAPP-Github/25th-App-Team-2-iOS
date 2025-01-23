//
//  KeyChainManager.swift
//  Data
//
//  Created by 박민서 on 1/21/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// KeyChainManager
/// - 키체인을 통해 데이터를 CRUD 하기 위한 유틸리티입니다.
public struct KeyChainManager {
    
    // MARK: - Create / Update
    /// 데이터를 키체인에 저장하거나 업데이트합니다.
    /// - Parameters:
    ///   - value: 저장할 데이터 (Generic 타입)
    ///   - key: Key 열거형으로 정의된 키
    /// - Throws: 타입 불일치, 데이터 변환 실패, 키체인 저장 실패 에러
    public static func save<T>(_ value: T, for key: Key) throws {
        
        guard type(of: value) == key.converter.type else {
            throw KeyChainError.typeMismatch(
                key: key.keyString,
                expected: key.converter.type,
                actual: type(of: value)
            )
        }
        
        let keyString: String = key.keyString
        let data: Data = Data("\(value)".utf8)

        try delete(key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyString,
            kSecValueData as String: data
        ]
        
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            throw KeyChainError.saveFailed(key: key.keyString, status: status)
        }
    }
    
    // MARK: - Read
    /// 키체인에서 데이터를 읽어옵니다.
    /// - Parameter key: Key 열거형으로 정의된 키
    /// - Returns: Generic 타입으로 변환된 값 (데이터가 없으면 nil)
    /// - Throws: 데이터 변환 실패, 읽기 실패, 타입 불일치 에러
    public static func read<T>(for key: Key) throws -> T? {
        let keyString: String = key.keyString
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyString,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecItemNotFound {
            return nil
        } else if status != errSecSuccess {
            throw KeyChainError.readFailed(key: key.keyString, status: status)
        }
        
        guard let data = result as? Data,
              let valueString = String(data: data, encoding: .utf8) else {
            throw KeyChainError.dataConversionError(key: key.keyString)
        }
        
        guard let value = key.converter.convert(valueString) as? T else {
            throw KeyChainError.typeMismatch(
                key: key.keyString,
                expected: key.converter.type,
                actual: String.self
            )
        }
        
        return value
    }
    
    // MARK: - Delete
    /// 키체인에서 데이터를 삭제합니다.
    /// - Parameter key: Key 열거형으로 정의된 키
    /// - Throws: 삭제 실패 에러
    public static func delete(_ key: Key) throws {
        let keyString: String = key.keyString
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyString
        ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw KeyChainError.deleteFailed(key: key.keyString, status: status)
        }
    }
}

public extension KeyChainManager {
    /// Key 열거형: 키체인에 저장할 데이터를 정의
    enum Key {
        case token
        case userId
        
        /// 키 고유 문자열
        var keyString: String {
            switch self {
            case .token: return "com.TnT.token"
            case .userId: return "com.TnT.userId"
            }
        }
        
        /// 각 데이터 별 타입 & 변환 로직 정의
        var converter: KeyConverter {
            switch self {
            case .token: return KeyConverter(type: String.self, convert: { $0 })
            case .userId: return KeyConverter(type: Int.self, convert: { Int($0) })
            }
        }
    }
    
    /// 키의 데이터 타입 + 변환 로직
    struct KeyConverter {
        let type: Any.Type
        let convert: (String) -> Any?
    }
    
    /// 키체인 관련 에러 정의
    enum KeyChainError: Error, CustomStringConvertible {
        case typeMismatch(key: String, expected: Any.Type, actual: Any.Type)
        case dataConversionError(key: String)
        case saveFailed(key: String, status: OSStatus)
        case readFailed(key: String, status: OSStatus)
        case deleteFailed(key: String, status: OSStatus)
        
        public var description: String {
            switch self {
            case .typeMismatch(let key, let expected, let actual):
                return "타입 불일치: 키 \(key)에서 기대한 타입은 \(expected)였으나 실제 타입은 \(actual)입니다."
            case .dataConversionError(let key):
                return "데이터 변환 실패: 키 \(key)의 데이터를 문자열로 변환할 수 없습니다."
            case .saveFailed(let key, let status):
                return "저장 실패: 키 \(key)를 저장하는 중 오류가 발생했습니다. (OSStatus: \(status))"
            case .readFailed(let key, let status):
                return "읽기 실패: 키 \(key)의 데이터를 읽는 중 오류가 발생했습니다. (OSStatus: \(status))"
            case .deleteFailed(let key, let status):
                return "삭제 실패: 키 \(key)를 삭제하는 중 오류가 발생했습니다. (OSStatus: \(status))"
            }
        }
    }
}

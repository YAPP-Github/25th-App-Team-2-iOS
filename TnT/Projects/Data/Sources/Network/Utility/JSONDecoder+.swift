//
//  JSONDecoder.swift
//  Data
//
//  Created by 박민서 on 1/22/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

extension JSONDecoder {
    convenience init(setting: Setting) {
        self.init()
        self.dateDecodingStrategy = setting.dateDecodingStrategy
        self.keyDecodingStrategy = setting.keyDecodingStrategy
    }
    
    enum Setting {
        case defaultSetting
        case custom(dateStrategy: DateDecodingStrategy, keyStrategy: KeyDecodingStrategy)

        var dateDecodingStrategy: DateDecodingStrategy {
            switch self {
            case .defaultSetting:
                return .iso8601
            case .custom(let dateStrategy, _):
                return dateStrategy
            }
        }

        var keyDecodingStrategy: KeyDecodingStrategy {
            switch self {
            case .defaultSetting:
                return .convertFromSnakeCase
            case .custom(_, let keyStrategy):
                return keyStrategy
            }
        }
    }
}

//
//  APIKey.swift
//  Geminimalistic
//
//  Created by Pavel Lahoda on 28.01.2024.
//

import Foundation

enum APIKey {
    static var `default`: String {
        return APIKeyModel.apiKey ?? ""
    }
}

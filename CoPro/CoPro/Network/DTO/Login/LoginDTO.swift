//
//  LoginDTO.swift
//  CoPro
//
//  Created by 박현렬 on 2/13/24.
//

import Foundation

// MARK: - LoginDTO
class LoginDTO: Codable {
    let statusCode: Int
    let message: String
    let data: TokenClass

    init(statusCode: Int, message: String, data: TokenClass) {
        self.statusCode = statusCode
        self.message = message
        self.data = data
    }
}

// MARK: - TokenClass
class TokenClass: Codable {
    let accessToken, refreshToken: String

    init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

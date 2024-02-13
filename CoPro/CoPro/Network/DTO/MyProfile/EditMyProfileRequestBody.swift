//
//  EditMyProfileRequestBody.swift
//  CoPro
//
//  Created by 박신영 on 2/9/24.
//

import Foundation

// MARK: - EditMyProfileRequestBody
struct EditMyProfileRequestBody: Codable {
    var nickName, occupation, language: String
    var career: Int
    
    init(nickName: String = "", occupation: String = "", language: String = "", career: Int = 0) {
        self.nickName = nickName
        self.occupation = occupation
        self.language = language
        self.career = career
    }
}

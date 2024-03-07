//
//  MyProfileDTO.swift
//  CoPro
//
//  Created by 박신영 on 1/21/24.
//

import Foundation

// MARK: - MyProfileDTO
struct MyProfileDTO: Codable {
    let statusCode: Int
    let message: String
    let data: MyProfileData
}

// MARK: - MyProfileData
struct MyProfileData: Codable {
    let picture, occupation, language, nickName, email: String
    let gitHubURL: String?
    let career, viewType, likeMembersCount: Int

    enum CodingKeys: String, CodingKey {
        case picture, occupation, language, career, email
        case gitHubURL = "gitHubUrl"
        case nickName, viewType, likeMembersCount
    }
}

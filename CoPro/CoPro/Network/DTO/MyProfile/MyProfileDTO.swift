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
    let name, picture, occupation, language: String
    let career, gitHubURL, nickName: String
    let viewType, likeMembersCount: Int

    enum CodingKeys: String, CodingKey {
        case name, picture, occupation, language, career
        case gitHubURL = "gitHubUrl"
        case nickName, viewType, likeMembersCount
    }
}

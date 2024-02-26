//
//  OppositeInfoDTO.swift
//  CoPro
//
//  Created by 박신영 on 2/26/24.
//

import Foundation

// MARK: - OppositeInfoDTO
struct OppositeInfoDTO: Codable {
    let statusCode: Int
    let message: String
    let data: OppositeInfoDataClass
}

// MARK: - OppositeInfoDataClass
struct OppositeInfoDataClass: Codable {
    let memberID: Int
    let name, email: String
    let picture: String
    let occupation, language: String
    let career: Int
    let gitHubURL: String
    let nickName: String
    let likeMembersCount: Int
    let isLikeMembers: Bool

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case name, email, picture, occupation, language, career
        case gitHubURL = "gitHubUrl"
        case nickName, likeMembersCount, isLikeMembers
    }
}

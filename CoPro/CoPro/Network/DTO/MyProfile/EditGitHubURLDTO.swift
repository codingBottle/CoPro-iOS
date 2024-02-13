//
//  EditGitHubURLDTO.swift
//  CoPro
//
//  Created by 박신영 on 1/25/24.
//

import Foundation

struct EditGitHubURLDTO: Codable {
    let statusCode: Int
    let message: String
    let data: EditGitHubURLDataClass
}

struct EditGitHubURLDataClass: Codable {
    let memberID: Int
    let name, email, picture, occupation: String
    let language, career, gitHubURL, nickName: String
    let likeMembersCount: Int
    let isLikeMembers: Bool

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case name, email, picture, occupation, language, career
        case gitHubURL = "gitHubUrl"
        case nickName, likeMembersCount, isLikeMembers
    }
}

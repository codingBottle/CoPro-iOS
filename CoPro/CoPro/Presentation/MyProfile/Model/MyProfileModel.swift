//
//  MyProfileModel.swift
//  CoPro
//
//  Created by 박신영 on 1/21/24.
//

import Foundation

struct MyProfileModel: Codable {
    var name, picture, occupation, language: String
    var career, gitHubURL, nickName: String
    var viewType, likeMembersCount: Int

    enum CodingKeys: String, CodingKey {
        case name, picture, occupation, language, career
        case gitHubURL = "gitHubUrl"
        case nickName, viewType, likeMembersCount
    }
}

//
//  MyProfileModel.swift
//  CoPro
//
//  Created by 박신영 on 1/21/24.
//

import Foundation

struct MyProfileDataModel: Codable {
    var name, picture, occupation, language: String
    var gitHubURL, nickName: String
    var career, viewType, likeMembersCount: Int
    
    init(from data: MyProfileData) {
        self.name = data.name
                self.picture = data.picture
                self.occupation = data.occupation
                self.language = data.language
                self.career = data.career
                self.gitHubURL = data.gitHubURL
                self.nickName = data.nickName
                self.viewType = data.viewType
                self.likeMembersCount = data.likeMembersCount
    }

    enum CodingKeys: String, CodingKey {
        case name, picture, occupation, language, career
        case gitHubURL = "gitHubUrl"
        case nickName, viewType, likeMembersCount
    }
}

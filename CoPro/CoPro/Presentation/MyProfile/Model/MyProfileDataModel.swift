//
//  MyProfileModel.swift
//  CoPro
//
//  Created by 박신영 on 1/21/24.
//

import Foundation

struct MyProfileDataModel: Codable {
    var picture, occupation, language, nickName, email: String
    var gitHubURL: String?
    var career, viewType, likeMembersCount: Int
    
   init(from data: MyProfileData) {
      self.picture = data.picture
      self.occupation = data.occupation
      self.language = data.language
      self.career = data.career
      self.gitHubURL = data.gitHubURL
      self.nickName = data.nickName
      self.viewType = data.viewType
      self.likeMembersCount = data.likeMembersCount
      self.email = data.email
   }

    enum CodingKeys: String, CodingKey {
        case picture, occupation, language, career, email
        case gitHubURL = "gitHubUrl"
        case nickName, viewType, likeMembersCount
    }
}

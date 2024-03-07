//
//  ChattingNotificationRequestBody.swift
//  CoPro
//
//  Created by 박신영 on 2/20/24.
//

import Foundation

// MARK: - ChattingNotificationRequestBody

struct ChattingNotificationRequestBody: Codable {
    let targetMemberEmail, title, body: String
   let data: ChattingNotificationDataClass
   
//   init(targetMemberEmail: String, title: String, body: String) {
//      self.targetMemberEmail = targetMemberEmail
//      self.title = title
//      self.body = body
//      self.data = data
//   }
}

struct ChattingNotificationDataClass: Codable {
    let channelId: String
}

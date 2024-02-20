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
   
   init(targetMemberEmail: String, title: String, body: String) {
      self.targetMemberEmail = targetMemberEmail
      self.title = title
      self.body = body
   }
}

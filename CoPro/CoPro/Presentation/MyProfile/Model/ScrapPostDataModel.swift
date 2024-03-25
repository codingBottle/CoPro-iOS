//
//  ScrapPostDataModel.swift
//  CoPro
//
//  Created by 박신영 on 2/3/24.
//

import Foundation

struct ScrapPostDataModel: Codable {
   let boardID: Int
   let title: String
   let count: Int
   let createAt: String
   let heart: Int
   let category: String
   let imageURL: String?
   let nickName: String
   let commentCount: Int
   
   init(boardID: Int, title: String, count: Int, createAt: String, heart: Int, imageURL: String, nickName: String, commentCount: Int, category: String) {
      self.boardID = boardID
      self.title = title
      self.count = count
      self.createAt = createAt
      self.heart = heart
      self.imageURL = imageURL
      self.nickName = nickName
      self.commentCount = commentCount
      self.category = category
   }
   
   enum CodingKeys: String, CodingKey {
      case boardID = "boardId"
      case title, count, createAt, heart, category
      case imageURL = "imageUrl"
      case nickName, commentCount
   }
   
   func getScrapPostDateString() -> String {
       let inputFormatter = DateFormatter()
       inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
       inputFormatter.locale = Locale(identifier: "en_US_POSIX") // ISO 8601 format
        let zeroFormatter = DateFormatter()
        zeroFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        zeroFormatter.locale = Locale(identifier: "en_US_POSIX")
        zeroFormatter.timeZone = TimeZone(abbreviation: "KST")
       if let date = inputFormatter.date(from: createAt) {
          let outputFormatter = DateFormatter()
          outputFormatter.dateFormat = "MM/dd HH:mm"
          return outputFormatter.string(from: date)
       } else if let date = zeroFormatter.date(from: createAt) {
           let outputFormatter = DateFormatter()
           outputFormatter.dateFormat = "MM/dd HH:mm"
           return outputFormatter.string(from: date)
       }else{
           let date = Date()
           let outputFormatter = DateFormatter()
           outputFormatter.dateFormat = "MM/dd HH:mm"
           return outputFormatter.string(from: date)
       }
   }
}

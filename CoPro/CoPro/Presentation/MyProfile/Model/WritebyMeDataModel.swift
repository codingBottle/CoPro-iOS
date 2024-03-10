//
//  WritebyMeDataModel.swift
//  CoPro
//
//  Created by 박신영 on 2/2/24.
//

import Foundation

// MARK: - Board
struct WritebyMeDataModel: Codable {
   let boardId: Int
   let title, nickName, createAt: String
   let count, heart: Int
   let imageURL: String?
   let commentCount: Int
   let category: String
   
   init(boardId: Int, title: String, nickName: String, createAt: String, count: Int, heart: Int, imageURL: String, commentCount: Int, category: String) {
      self.boardId = boardId
      self.title = title
      self.nickName = nickName
      self.createAt = createAt
      self.count = count
      self.heart = heart
      self.imageURL = imageURL
      self.commentCount = commentCount
      self.category = category
   }
   
   enum CodingKeys: String, CodingKey {
      case boardId, title, nickName, createAt, count, heart, category
      case imageURL = "imageUrl"
      case commentCount
   }
   
   func getWritebyMeDateString() -> String {
      let inputFormatter = DateFormatter()
      inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
      inputFormatter.locale = Locale(identifier: "en_US_POSIX") // ISO 8601 format
      
      if let date = inputFormatter.date(from: createAt) {
         let outputFormatter = DateFormatter()
         outputFormatter.dateFormat = "MM/dd HH:mm"
         return outputFormatter.string(from: date)
      } else {
         return "Invalid date format"
      }
   }
}

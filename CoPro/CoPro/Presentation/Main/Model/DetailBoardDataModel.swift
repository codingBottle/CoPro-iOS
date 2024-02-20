//
//  DetailBoardDateModel.swift
//  CoPro
//
//  Created by 문인호 on 1/22/24.
//

import Foundation

struct DetailBoardDataModel {
   let boardId: Int
   let title: String
   var createAt: Date
   let category: String
   let contents: String?
   let tag: String?
   let count: Int
   let heart: Int
   let imageUrl: [String]?
   let nickName: String
   let occupation: String?
   let part: String?
   let isHeart: Bool
   let isScrap: Bool
   let commentCount: Int
   let email: String
   let picture: String
   
   init(boardId: Int, title: String, createAt: String,category: String, contents: String?, tag: String?, count: Int, heart: Int, imageUrl: [String]?, nickName: String, occupation: String?, isHeart: Bool, isScrap: Bool, commentCount: Int, part: String?, email: String, picture: String) {
      self.boardId = boardId
      self.title = title
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
      formatter.locale = Locale(identifier: "en_US_POSIX")
      //                formatter.timeZone = TimeZone(secondsFromGMT: 9 * 60 * 60)
      formatter.timeZone = TimeZone(abbreviation: "KST")
      
      if let date = formatter.date(from: createAt) {
         self.createAt = date
      } else {
         fatalError("Invalid date format")
      }
      self.category = category
      self.contents = contents
      self.tag = tag
      self.count = count
      self.heart = heart
      self.imageUrl = imageUrl
      self.nickName = nickName
      self.occupation = occupation
      self.isHeart = isHeart
      self.isScrap = isScrap
      self.commentCount = commentCount
      self.part = part
      self.email = email
      self.picture = picture
   }
   
   func getDateString() -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = "MM/dd"
      return formatter.string(from: createAt)
   }
   
   func getTimeString() -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = "HH:mm"
      return formatter.string(from: createAt)
   }
   
}

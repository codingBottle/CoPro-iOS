//
//  BoardDataModel.swift
//  CoPro
//
//  Created by 문인호 on 1/16/24.
//

import Foundation

struct BoardDataModel {
    var boardId: Int
    var title: String
    var nickName: String
    var createAt: Date
//    var empathy: likeButtonStatus
    var heartCount: Int
    var viewsCount: Int
    var imageUrl: String
    var commentCount: Int

    init(boardId: Int, title: String, nickName: String, createAt: String, heartCount: Int, viewsCount: Int, imageUrl: String, commentCount: Int) {
        self.boardId = boardId
        self.title = title
        self.nickName = nickName
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
//        self.empathy = empathy
        self.heartCount = heartCount
        self.viewsCount = viewsCount
        self.imageUrl = imageUrl
        self.commentCount = commentCount
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

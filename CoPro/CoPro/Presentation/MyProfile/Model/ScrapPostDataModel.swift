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
    let imageURL: String
    let nickName: String
    let commentCount: Int
    
    init(boardID: Int, title: String, count: Int, createAt: String, heart: Int, imageURL: String, nickName: String, commentCount: Int) {
        self.boardID = boardID
        self.title = title
        self.count = count
        self.createAt = createAt
        self.heart = heart
        self.imageURL = imageURL
        self.nickName = nickName
        self.commentCount = commentCount
    }

    enum CodingKeys: String, CodingKey {
        case boardID = "boardId"
        case title, count, createAt, heart
        case imageURL = "imageUrl"
        case nickName, commentCount
    }
    
//    let id: Int
//    let title, nickName, createAt: String
//    let count, heart: Int
//    let imageURL: String
//    let commentCount: Int
//    
//    init(id: Int, title: String, nickName: String, createAt: String, count: Int, heart: Int, imageURL: String, commentCount: Int) {
//        self.id = id
//        self.title = title
//        self.nickName = nickName
//        self.createAt = createAt
//        self.count = count
//        self.heart = heart
//        self.imageURL = imageURL
//        self.commentCount = commentCount
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case id, title, nickName, createAt, count, heart
//        case imageURL = "imageUrl"
//        case commentCount
//    }
    
    func getScrapPostDateString() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
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

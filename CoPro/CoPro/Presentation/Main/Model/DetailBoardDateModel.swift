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
    let contents: String
    let tag: String
    let count: Int
    let heart: Int
    let imageUrl: [String]?
    let nickName: String
    let occupation: String
    let heartMemberIds: [Int]?
    let scrapMemberIds: [Int]?
    let comments: [Comment]?

    init(boardId: Int, title: String, createAt: String,category: String, contents: String, tag: String, count: Int, heart: Int, imageUrl: [String]?, nickName: String, occupation: String, heartMemberIds: [Int]?, scrapMemberIds: [Int]?, comments: [Comment]?) {
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
        self.heartMemberIds = heartMemberIds
        self.scrapMemberIds = scrapMemberIds
        self.comments = comments
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

struct CommentData {
    let commentId: Int
    let content: String
    let writer: WriterData
    let children: [CommentData]?

    init(commentId: Int, content: String, writer: WriterData, children: [CommentData]?) {
        self.commentId = commentId
        self.content = content
        self.writer = writer
        self.children = children
    }
}

struct WriterData {
    let nickName: String
    let occupation: String

    init(nickName: String, occupation: String) {
        self.nickName = nickName
        self.occupation = occupation
    }
}

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

    init(boardId: Int, title: String, category: String, contents: String, tag: String, count: Int, heart: Int, imageUrl: [String]?, nickName: String, occupation: String, heartMemberIds: [Int]?, scrapMemberIds: [Int]?, comments: [Comment]?) {
        self.boardId = boardId
        self.title = title
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

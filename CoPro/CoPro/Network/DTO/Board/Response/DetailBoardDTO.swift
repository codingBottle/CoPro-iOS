//
//  DetailBoardDTO.swift
//  CoPro
//
//  Created by 문인호 on 1/16/24.
//

import Foundation

// MARK: - DetailBoardDTO
// 상세페이지, 수정, 등록
struct DetailBoardDTO: Codable {
    let boardID: Int
    let title, category, contents, tag: String
    let count, heart: Int
    let imageURL: [String]
    let nickName, occupation: String
    let heartMemberIDS, scrapMemberIDS: [Int]
    let commentResDtoList: [CommentResDtoList]

    enum CodingKeys: String, CodingKey {
        case boardID = "boardId"
        case title, category, contents, tag, count, heart
        case imageURL = "imageUrl"
        case nickName, occupation
        case heartMemberIDS = "heartMemberIds"
        case scrapMemberIDS = "scrapMemberIds"
        case commentResDtoList
    }
}

// MARK: - CommentResDtoList
struct CommentResDtoList: Codable {
    let commentID: Int
    let content: String
    let writer: Writer

    enum CodingKeys: String, CodingKey {
        case commentID = "commentId"
        case content, writer
    }
}

// MARK: - Writer
struct Writer: Codable {
    let nickName, occupation: String
}

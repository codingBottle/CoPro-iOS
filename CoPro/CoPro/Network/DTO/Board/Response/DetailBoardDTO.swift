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
    let statusCode: Int
        let message: String
        let data: BoardData
    }

    struct BoardData: Codable {
        let boardId: Int
        let title, createAt, category, contents, tag: String
        let count: Int
        let heart: Int
        let imageUrl: [String]?
        let nickName: String?
        let occupation: String?
        let heartMemberIds: [Int]?
        let scrapMemberIds: [Int]?
        let commentResDtoList: [Comment]?
    }

    struct Comment: Codable {
        let parendId: Int?
        let commentId: Int
        let content: String
        let writer: Writer?
        let children: [Comment]?
    }

    struct Writer: Codable {
        let nickName: String
        let occupation: String
    }

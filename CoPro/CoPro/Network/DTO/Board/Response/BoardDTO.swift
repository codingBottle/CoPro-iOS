//
//  BoardDTO.swift
//  CoPro
//
//  Created by 문인호 on 1/16/24.
//

import Foundation

// MARK: - BoardDataModel
// 게시물 검색, 게시물 조회
struct BoardDTO: Codable {
    let message: String
    let statusCode: Int
    let data:boardData
}

//MARK: - Data
struct boardData: Codable {
    let boards: [Board]
    let pageInfo: PageInfo
}

// MARK: - Board
struct Board: Codable {
    let id: Int
    let title, nickName, createAt: String?
    let count, heart: Int
    let imageURL: String?
    let commentCount: Int

    enum CodingKeys: String, CodingKey {
        case id, title, nickName, createAt, count, heart
        case imageURL = "imageUrl"
        case commentCount
    }
}

// MARK: - PageInfo
struct PageInfo: Codable {
    let currentPage, size: Int
    let hasNext, hasPrevious: Bool
    let numberOfElements, totalElements, totalPages: Int
    let first, last: Bool
}

//
//  WritebyMeDTO.swift
//  CoPro
//
//  Created by 박신영 on 2/1/24.
//


import Foundation

// MARK: - WritebyMeDTO
struct WritebyMeDTO: Codable {
    let statusCode: Int
    let message: String
    let data: WritebyMeData
}

// MARK: - DataClass
struct WritebyMeData: Codable {
    let boards: [WritebyMeBoard]
    let pageInfo: WritebyMePageInfo
}

// MARK: - Board
struct WritebyMeBoard: Codable {
    let id: Int
    let title, nickName, createAt: String
    let count, heart: Int
    let imageURL: String
    let commentCount: Int

    enum CodingKeys: String, CodingKey {
        case id, title, nickName, createAt, count, heart
        case imageURL = "imageUrl"
        case commentCount
    }
}

// MARK: - PageInfo
struct WritebyMePageInfo: Codable {
    let currentPage, size: Int
    let hasNext, hasPrevious: Bool
    let numberOfElements, totalElements, totalPages: Int
    let first, last: Bool
}

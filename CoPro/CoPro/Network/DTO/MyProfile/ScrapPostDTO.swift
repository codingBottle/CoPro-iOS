//
//  ScrapPostDTO.swift
//  CoPro
//
//  Created by 박신영 on 2/3/24.
//

import Foundation

// MARK: - ScrapPostDTO
struct ScrapPostDTO: Codable {
    let statusCode: Int
    let message: String
    let data: ScrapPostDataClass
}

// MARK: - ScrapPostDataClass
struct ScrapPostDataClass: Codable {
    let number: Int
    let content: [ScrapPostContent]
    let pageable: ScrapPostPageable
    let sort: ScrapPostSort
    let numberOfElements, totalPages, size: Int
    let last, empty: Bool
    let totalElements: Int
    let first: Bool
}

// MARK: - ScrapPostContent
struct ScrapPostContent: Codable {
    let boardID: Int
    let title: String
    let count: Int
    let createAt: String
    let heart: Int
    let imageURL: String
    let nickName: String
    let commentCount: Int

    enum CodingKeys: String, CodingKey {
        case boardID = "boardId"
        case title, count, createAt, heart
        case imageURL = "imageUrl"
        case nickName, commentCount
    }
}

// MARK: - ScrapPostPageable
struct ScrapPostPageable: Codable {
    let unpaged: Bool
    let pageNumber, offset, pageSize: Int
    let sort: ScrapPostSort
    let paged: Bool
}

// MARK: - ScrapPostSort
struct ScrapPostSort: Codable {
    let sorted, empty, unsorted: Bool
}

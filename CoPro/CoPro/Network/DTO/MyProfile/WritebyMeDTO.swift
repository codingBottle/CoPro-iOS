//
//  WritebyMeDTO.swift
//  CoPro
//
//  Created by 박신영 on 2/1/24.
//


import Foundation

// MARK: - WritebyMeDTO
//struct WritebyMeDTO: Codable {
//    let statusCode: Int
//    let message: String
//    let data: WritebyMeData
//}
//
//// MARK: - DataClass
//struct WritebyMeData: Codable {
//    let boards: [WritebyMeBoard]
//    let pageInfo: WritebyMePageInfo
//}
//
//// MARK: - Board
//struct WritebyMeBoard: Codable {
//    let id: Int
//    let title, nickName, createAt, category: String
//    let count, heart: Int
//    let imageURL: String?
//    let commentCount: Int
//
//    enum CodingKeys: String, CodingKey {
//        case id, title, nickName, createAt, count, heart, category
//        case imageURL = "imageUrl"
//        case commentCount
//    }
//}
//
//// MARK: - PageInfo
//struct WritebyMePageInfo: Codable {
//    let currentPage, size: Int
//    let hasNext, hasPrevious: Bool
//    let numberOfElements, totalElements, totalPages: Int
//    let first, last: Bool
//}


// MARK: - WritebyMeDTO
struct WritebyMeDTO: Codable {
    let statusCode: Int
    let message: String
    let data: WritebyMeData
}

// MARK: - DataClass
struct WritebyMeData: Codable {
    let content: [WritebyMeContent]
    let pageable: WritebyMePageable
    let last: Bool
    let totalPages, totalElements: Int
    let first: Bool
    let size, number: Int
    let sort: Sort
    let numberOfElements: Int
    let empty: Bool
}

// MARK: - Content
struct WritebyMeContent: Codable {
    let boardId: Int
    let category, title, nickName, createAt: String
    let count, heart: Int
    let imageURL: String?
    let commentCount: Int

    enum CodingKeys: String, CodingKey {
        case boardId, category, title, nickName, createAt, count, heart
        case imageURL = "imageUrl"
        case commentCount
    }
}

// MARK: - Pageable
struct WritebyMePageable: Codable {
    let pageNumber, pageSize: Int
    let sort: WritebyMeSort
    let offset: Int
    let paged, unpaged: Bool
}

// MARK: - Sort
struct WritebyMeSort: Codable {
    let empty, unsorted, sorted: Bool
}

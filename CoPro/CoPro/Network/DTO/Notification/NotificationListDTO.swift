//
//  NotificationListDTO.swift
//  CoPro
//
//  Created by 박현렬 on 2/22/24.
//

import Foundation
import Foundation

// MARK: - NotificationListDTO
class NotificationListDTO: Codable {
    let statusCode: Int
    let message: String
    let data: NotificationListData

    init(statusCode: Int, message: String, data: NotificationListData) {
        self.statusCode = statusCode
        self.message = message
        self.data = data
    }
}

// MARK: - NotificationListData
class NotificationListData: Codable {
    let totalPages, totalElements: Int
    let pageable: NotificationListDataPageable
    let size: Int
    let content: [NotificationListDataContent]
    let number: Int
    let sort: NotificationListDataSort
    let numberOfElements: Int
    let first, last, empty: Bool

    init(totalPages: Int, totalElements: Int, pageable: NotificationListDataPageable, size: Int, content: [NotificationListDataContent], number: Int, sort: NotificationListDataSort, numberOfElements: Int, first: Bool, last: Bool, empty: Bool) {
        self.totalPages = totalPages
        self.totalElements = totalElements
        self.pageable = pageable
        self.size = size
        self.content = content
        self.number = number
        self.sort = sort
        self.numberOfElements = numberOfElements
        self.first = first
        self.last = last
        self.empty = empty
    }
}

// MARK: - Content
class NotificationListDataContent: Codable {
    let message: String
    let boardID: Int?

    enum CodingKeys: String, CodingKey {
        case message
        case boardID = "boardId"
    }

    init(message: String, boardID: Int) {
        self.message = message
        self.boardID = boardID
    }
}

// MARK: - Pageable
class NotificationListDataPageable: Codable {
    let pageNumber, pageSize, offset: Int
    let sort: NotificationListDataSort
    let paged, unpaged: Bool

    init(pageNumber: Int, pageSize: Int, offset: Int, sort: NotificationListDataSort, paged: Bool, unpaged: Bool) {
        self.pageNumber = pageNumber
        self.pageSize = pageSize
        self.offset = offset
        self.sort = sort
        self.paged = paged
        self.unpaged = unpaged
    }
}

// MARK: - Sort
class NotificationListDataSort: Codable {
    let sorted, empty, unsorted: Bool

    init(sorted: Bool, empty: Bool, unsorted: Bool) {
        self.sorted = sorted
        self.empty = empty
        self.unsorted = unsorted
    }
}

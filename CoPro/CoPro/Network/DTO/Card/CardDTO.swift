//
//  CardModel.swift
//  CoPro
//
//  Created by 박현렬 on 1/1/24.
//

import Foundation

// MARK: - CardDTO
class CardDTO: Codable {
    let statusCode: Int
    let message: String
    let data: cardDataClass
    
    init(statusCode: Int, message: String, data: cardDataClass) {
        self.statusCode = statusCode
        self.message = message
        self.data = data
    }
}

// MARK: - DataClass
class cardDataClass: Codable {
    let myViewType: Int
    let memberResDto: MemberResDto
    
    init(myViewType: Int, memberResDto: MemberResDto) {
        self.myViewType = myViewType
        self.memberResDto = memberResDto
    }
}

// MARK: - MemberResDto
class MemberResDto: Codable {
    let totalPages, totalElements, size: Int
    let content: [Content]
    let number: Int
    let sort: Sort
    let numberOfElements: Int
    let pageable: Pageable
    let first, last, empty: Bool
    
    init(totalPages: Int, totalElements: Int, size: Int, content: [Content], number: Int, sort: Sort, numberOfElements: Int, pageable: Pageable, first: Bool, last: Bool, empty: Bool) {
        self.totalPages = totalPages
        self.totalElements = totalElements
        self.size = size
        self.content = content
        self.number = number
        self.sort = sort
        self.numberOfElements = numberOfElements
        self.pageable = pageable
        self.first = first
        self.last = last
        self.empty = empty
    }
}

// MARK: - Content
class Content: Codable {
    let memberId: Int?
    let name, email, picture: String?
    let occupation: String?
    let language: String?
    let career: Int?
    let gitHubURL: String?
    let nickName: String?
    let likeMembersCount: Int?
    let isLikeMembers: Bool
    
    enum CodingKeys: String, CodingKey {
        case memberId,name, email, picture, occupation, language, career, isLikeMembers
        case gitHubURL = "gitHubUrl"
        case nickName, likeMembersCount
    }
    
    init(memberId: Int,name: String, email: String, picture: String, occupation: String, language: String, career: Int, gitHubURL: String, nickName: String, likeMembersCount: Int, likeMembersID: [Int], isLikeMembers: Bool) {
        self.memberId = memberId
        self.name = name
        self.email = email
        self.picture = picture
        self.occupation = occupation
        self.language = language
        self.career = career
        self.gitHubURL = gitHubURL
        self.nickName = nickName
        self.likeMembersCount = likeMembersCount
        self.isLikeMembers = isLikeMembers
    }
}

// MARK: - Pageable
class Pageable: Codable {
    let offset: Int
    let sort: Sort
    let pageNumber, pageSize: Int
    let paged, unpaged: Bool
    
    init(offset: Int, sort: Sort, pageNumber: Int, pageSize: Int, paged: Bool, unpaged: Bool) {
        self.offset = offset
        self.sort = sort
        self.pageNumber = pageNumber
        self.pageSize = pageSize
        self.paged = paged
        self.unpaged = unpaged
    }
}

// MARK: - Sort
class Sort: Codable {
    let empty, sorted, unsorted: Bool
    
    init(empty: Bool, sorted: Bool, unsorted: Bool) {
        self.empty = empty
        self.sorted = sorted
        self.unsorted = unsorted
    }
}

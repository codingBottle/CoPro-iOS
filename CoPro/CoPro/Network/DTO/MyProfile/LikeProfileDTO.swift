//
//  LikeProfileDTO.swift
//  CoPro
//
//  Created by 박현렬 on 2/18/24.
//

import Foundation

// MARK: - LikeProfileDTO
class LikeProfileDTO: Codable {
    let statusCode: Int
    let message: String
    let data: LikeProfileDataClass
    
    init(statusCode: Int, message: String, data: LikeProfileDataClass) {
        self.statusCode = statusCode
        self.message = message
        self.data = data
    }
}

// MARK: - LikeProfileDataClass
class LikeProfileDataClass: Codable {
    let totalPages, totalElements: Int
    let pageable: LikeProfilePageable
    let size: Int
    let content: [LikeProfileContent]
    let number: Int
    let sort: Sort
    let numberOfElements: Int
    let first, last, empty: Bool
    
    init(totalPages: Int, totalElements: Int, pageable: LikeProfilePageable, size: Int, content: [LikeProfileContent], number: Int, sort: Sort, numberOfElements: Int, first: Bool, last: Bool, empty: Bool) {
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
class LikeProfileContent: Codable {
    let memberLikeID: Int
    let name, email, picture, occupation: String
    let language: String
    let career: Int
    let gitHubURL: String?
    let isLike: Bool
    let likeMembersCount: Int
    
    enum CodingKeys: String, CodingKey {
        case memberLikeID = "memberLikeId"
        case name, email, picture, occupation, language, career
        case gitHubURL = "gitHubUrl"
        case isLike, likeMembersCount
    }
    
    init(memberLikeID: Int, name: String, email: String, picture: String, occupation: String, language: String, career: Int, gitHubURL: String, isLike: Bool, likeMembersCount: Int) {
        self.memberLikeID = memberLikeID
        self.name = name
        self.email = email
        self.picture = picture
        self.occupation = occupation
        self.language = language
        self.career = career
        self.gitHubURL = gitHubURL
        self.isLike = isLike
        self.likeMembersCount = likeMembersCount
    }
}

// MARK: - Pageable
class LikeProfilePageable: Codable {
    let pageNumber, pageSize, offset: Int
    let sort: LikeProfileSort
    let paged, unpaged: Bool
    
    init(pageNumber: Int, pageSize: Int, offset: Int, sort: LikeProfileSort, paged: Bool, unpaged: Bool) {
        self.pageNumber = pageNumber
        self.pageSize = pageSize
        self.offset = offset
        self.sort = sort
        self.paged = paged
        self.unpaged = unpaged
    }
}

// MARK: - Sort
class LikeProfileSort: Codable {
    let sorted, empty, unsorted: Bool
    
    init(sorted: Bool, empty: Bool, unsorted: Bool) {
        self.sorted = sorted
        self.empty = empty
        self.unsorted = unsorted
    }
}

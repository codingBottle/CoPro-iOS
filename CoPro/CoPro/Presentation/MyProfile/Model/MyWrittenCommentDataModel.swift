//
//  MyWrittenCommentDataModel.swift
//  CoPro
//
//  Created by 박신영 on 2/2/24.
//

import Foundation

// MARK: - MyWrittenCommentDataModel
struct MyWrittenCommentDataModel: Codable {
    let parentID, commentID: Int
    let content, createAt: String
    let writer: MyWrittenCommentDataModelWriter
    
    init(parentID: Int, commentID: Int, content: String, createAt: String, writer: MyWrittenCommentDataModelWriter) {
        self.parentID = parentID
        self.commentID = commentID
        self.content = content
        self.createAt = createAt
        self.writer = writer
    }

    enum CodingKeys: String, CodingKey {
        case parentID = "parentId"
        case commentID = "commentId"
        case content, createAt, writer
    }
    
    func getMyWrittenCommentDateString() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") // ISO 8601 format
         let zeroFormatter = DateFormatter()
         zeroFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
         zeroFormatter.locale = Locale(identifier: "en_US_POSIX")
         zeroFormatter.timeZone = TimeZone(abbreviation: "KST")
        if let date = inputFormatter.date(from: createAt) {
           let outputFormatter = DateFormatter()
           outputFormatter.dateFormat = "MM/dd HH:mm"
           return outputFormatter.string(from: date)
        } else if let date = zeroFormatter.date(from: createAt) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MM/dd HH:mm"
            return outputFormatter.string(from: date)
        }else{
            let date = Date()
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MM/dd HH:mm"
            return outputFormatter.string(from: date)
        }
    }
}

extension MyWrittenCommentDataModelWriter {
    init(from writer: MyWrittenCommentWriter) {
        self.nickName = writer.nickName
        self.occupation = writer.occupation
    }
}


// MARK: - Writer
struct MyWrittenCommentDataModelWriter: Codable {
    let nickName, occupation: String
}

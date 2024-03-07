//
//  CommentDataModel.swift
//  CoPro
//
//  Created by 문인호 on 1/24/24.
//

import Foundation

struct DisplayComment {
    let comment: CommentData
    let level: Int  // 계층 수준
}

struct CommentData {
    let parentId: Int?
    let commentId: Int
    let content: String
    let writer: WriterData
    var createAt: Date
    let children: [CommentData]?

    init(parentId: Int?,commentId: Int, createAt: String,content: String, writer: WriterData, children: [CommentData]?) {
        self.parentId = parentId
        self.commentId = commentId
        self.content = content
        self.writer = writer
        self.children = children
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        //                formatter.timeZone = TimeZone(secondsFromGMT: 9 * 60 * 60)
        formatter.timeZone = TimeZone(abbreviation: "KST")
        
        let zeroFormatter = DateFormatter()
        zeroFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        zeroFormatter.locale = Locale(identifier: "en_US_POSIX")
        zeroFormatter.timeZone = TimeZone(abbreviation: "KST")
        
        if let date = formatter.date(from: createAt) {
            self.createAt = date
        } else if let date = zeroFormatter.date(from: createAt) {
            self.createAt = date
        }else {
            print("date error => \(createAt)")
            self.createAt = Date()
        }
    }
    
    func getDateString() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd"
            return formatter.string(from: createAt)
        }

        func getTimeString() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: createAt)
        }
}

struct WriterData {
    let nickName: String
    let occupation: String

    init(nickName: String, occupation: String) {
        self.nickName = nickName
        self.occupation = occupation
    }
}

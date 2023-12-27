//
//  noticeBoardDataModel.swift
//  CoPro
//
//  Created by 문인호 on 11/24/23.
//

import Foundation
import UIKit

struct noticeBoardDataModel {
    var title: String
    var author: String
    var timestamp: Date
    var empathy: likeButtonStatus
    var likes: Int
    var views: Int
    var commentCount: Int
}

@frozen
enum likeButtonStatus {
    case like
    case notLike
    
    var image: UIImage {
        switch self {
        case .like:
            return UIImage(systemName: "pawprint.fill")!.withTintColor(UIColor(hex: "F9ACAC"))
        case .notLike:
            return UIImage(systemName: "pawprint")!.withTintColor(UIColor(hex: "B9CDF7"))
        }
    }
}

extension noticeBoardDataModel {
    
    static func dummy() -> [noticeBoardDataModel] {
        return [
            noticeBoardDataModel(title: "Hello World!", author: "Author1", timestamp: .now, empathy: .like, likes: 10, views: 100, commentCount: 5),
            noticeBoardDataModel(title: "Ino!", author: "Author2", timestamp: .now, empathy: .notLike, likes: 20, views: 200, commentCount: 10),
            noticeBoardDataModel(title: "Shinyoung!", author: "Author3", timestamp: .now, empathy: .like, likes: 30, views: 300, commentCount: 15),
            noticeBoardDataModel(title: "Seonguen!", author: "Author4", timestamp: .now, empathy: .notLike, likes: 40, views: 400, commentCount: 20),
            noticeBoardDataModel(title: "Hyeonryeol!", author: "Author5", timestamp: .now, empathy: .like, likes: 50, views: 500, commentCount: 25)
        ]
    }
}

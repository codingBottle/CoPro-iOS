//
//  BoardDataModel.swift
//  CoPro
//
//  Created by 문인호 on 1/16/24.
//

import Foundation

struct BoardDataModel {
    var title: String
    var nickName: String
    var createAt: String
//    var empathy: likeButtonStatus
    var heartCount: Int
    var viewsCount: Int
    var imageUrl: String

    init(title: String, nickName: String, createAt: String, heartCount: Int, viewsCount: Int, imageUrl: String) {
        self.title = title
        self.nickName = nickName
        self.createAt = createAt
//        self.empathy = empathy
        self.heartCount = heartCount
        self.viewsCount = viewsCount
        self.imageUrl = imageUrl
    }
}

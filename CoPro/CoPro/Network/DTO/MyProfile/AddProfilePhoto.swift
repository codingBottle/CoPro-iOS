//
//  AddProfilePhoto.swift
//  CoPro
//
//  Created by 박신영 on 3/19/24.
//

import Foundation

// MARK: - AddProfilePhoto

struct AddProfilePhotoDTO: Codable {
    let statusCode: Int
    let message: String
    let data: AddProfilePhotoDataClass
}

// MARK: - DataClass
struct AddProfilePhotoDataClass: Codable {
    let imageID: Int
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case imageID = "imageId"
        case imageURL = "imageUrl"
    }
}


struct AddProfilePhotoRequestBody: Codable {
    let imageUrl: String
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
}

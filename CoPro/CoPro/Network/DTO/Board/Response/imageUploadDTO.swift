//
//  imageUploadDTO.swift
//  CoPro
//
//  Created by 문인호 on 2/13/24.
//

import Foundation

// MARK: - ImageUploadDTO
struct ImageUploadDTO: Codable {
    let statusCode: Int
    let message: String
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let imageID: Int
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case imageID = "imageId"
        case imageURL = "imageUrl"
    }
}

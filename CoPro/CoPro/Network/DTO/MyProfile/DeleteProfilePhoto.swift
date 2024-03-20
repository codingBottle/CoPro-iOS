//
//  DeleteProfilePhotoRequestBody.swift
//  CoPro
//
//  Created by 박신영 on 3/19/24.
//

import Foundation


// MARK: - DeleteProfilePhotoDTO


struct DeleteProfilePhotoDTO: Codable {
    let statusCode: Int
    let message: String
    let data: String?
}

// MARK: - DeleteProfilePhotoRequestBody

struct DeleteProfilePhotoRequestBody: Codable {
    let imageUrl: String
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
}

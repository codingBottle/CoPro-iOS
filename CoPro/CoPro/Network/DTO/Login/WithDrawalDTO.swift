//
//  WithDrawalDTO.swift
//  CoPro
//
//  Created by 박신영 on 3/18/24.
//

import Foundation

// MARK: - Temperatures
struct WithDrawalDTO: Codable {
    let statusCode: Int
    let message: String
    let data: WithDrawalDataClass
}

// MARK: - DataClass
struct WithDrawalDataClass: Codable {
    let email: String
}

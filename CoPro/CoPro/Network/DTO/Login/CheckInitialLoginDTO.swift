//
//  CheckInitialLoginDTO.swift
//  CoPro
//
//  Created by 박신영 on 2/16/24.
//

import Foundation

struct CheckInitialLoginDTO: Codable {
    let statusCode: Int
    let message: String
    let data: Bool
}

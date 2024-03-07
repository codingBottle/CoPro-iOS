//
//  FcmTokenDTO.swift
//  CoPro
//
//  Created by 박신영 on 2/19/24.
//

import Foundation

struct FcmTokenDTO: Codable {
   let statusCode: Int
   let message: String
   let data: String?
}

//
//  FcmTokenRequestBody.swift
//  CoPro
//
//  Created by 박신영 on 2/19/24.
//

import Foundation

struct FcmTokenRequestBody: Codable {
    var fcmToken: String
    
    init(fcmToken: String = "") {
        self.fcmToken = fcmToken
    }

    enum CodingKeys: String, CodingKey {
        case fcmToken = "fcmToken"
    }
}

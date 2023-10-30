//
//  BaseResponse.swift
//  CoPro
//
//  Created by 박신영 on 10/10/23.
//

import Foundation

struct SimpleResponse: Codable {
    var status: Int
    var success: Bool
    var message: String?
}

struct GenericResponse<T: Codable>: Codable {
    var status_code: Int?
    var success: Bool?
    var status_message: String?
}

// - MARK: 간단한 응답에 대한 모델, statuscode만 parsing함
struct VoidResult: Codable {
    var code: Int
    var data: Bool?
    var message: String?
}

// - MARK: 임시로 정의한 Error Template, 수정 가능
struct ErrorDTO: Codable {
    let statusCode: Int
    let data: String
    let errorMessage: String
}

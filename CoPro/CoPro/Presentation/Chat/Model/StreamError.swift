//
//  StreamError.swift
//  CoPro
//
//  Created by 박신영 on 12/27/23.
//

import Foundation

enum StreamError: Error {
    case firestoreError(Error?)
    case decodedError(Error?)
}

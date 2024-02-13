//
//  EditGitHubURLRequestBody.swift
//  CoPro
//
//  Created by 박신영 on 1/25/24.
//

import Foundation

// MARK: - Temperatures
struct EditGitHubURLRequestBody: Codable {
    var gitHubURL: String
    
    init(gitHubURL: String = "") {
        self.gitHubURL = gitHubURL
    }

    enum CodingKeys: String, CodingKey {
        case gitHubURL = "gitHubUrl"
    }
}

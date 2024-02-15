//
//  GitHubLoginManager.swift
//  CoPro
//
//  Created by 박현렬 on 2/14/24.
//

import Foundation
import KeychainSwift
import Alamofire
import UIKit
import KeychainSwift

class GitHubLoginManager {
    
    static let shared = GitHubLoginManager()
    let keychain = KeychainSwift()
    private init() {}
    var navigationController: UINavigationController?
    var client_id: String { return Config.gitHubClientId }
    
    
    func requestCode() {
        let scope = "repo,user"
        let urlString = "https://github.com/login/oauth/authorize?client_id=\(client_id)&scope=\(scope)"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func requestAccessToken(with code: String) {
        print(code)
        LoginAPI.shared.getAccessToken(authCode: code, provider: "github")
    }
    
    func logout() {
        KeychainSwift().clear()
    }
}

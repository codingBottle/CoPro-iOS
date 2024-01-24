//
//  AppController.swift
//  CoPro
//
//  Created by 박신영 on 12/27/23.
//

import Foundation
import Firebase
import UIKit
import FirebaseAuth

final class AppController {
    static let shared = AppController()
    private var window: UIWindow!
    private var rootViewController: UIViewController? {
        didSet {
            window.rootViewController = rootViewController
        }
    }
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkSignIn),
                                               name: .AuthStateDidChange,
                                               object: nil)
    }
    
    func show(in window: UIWindow?) {
        guard let window = window else {
            fatalError("Cannot layout app with a nil window.")
        }
        self.window = window
        window.tintColor = .primary
        window.backgroundColor = .systemBackground
        checkSignIn()
        window.makeKeyAndVisible()
    }

    @objc func checkSignIn() {
        if let user = Auth.auth().currentUser {
//            setCahnnelScene(with: user)
        } else {
            setLoginScene()
        }
    }
    
//    private func setCahnnelScene(with user: User) {
//        let channelVC = ChannelVC(currentUser: user)
//        let navigationController = BaseNavigationController(rootViewController: channelVC)
//        
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let sceneDelegate = windowScene.delegate as? SceneDelegate {
//            sceneDelegate.window?.rootViewController = navigationController
//            sceneDelegate.window?.makeKeyAndVisible()
//        }
//    }
    
    private func setLoginScene() {
        rootViewController = BaseNavigationController(rootViewController: LoginViewController())
    }
}


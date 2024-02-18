//
//  SceneDelegate.swift
//  CoPro
//
//  Created by 박신영 on 10/10/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
   
   var window: UIWindow?
   
   func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      guard let windowScene = (scene as? UIWindowScene) else { return }
      
      //        self.window = UIWindow(windowScene: windowScene)
      //        let navigationController = UINavigationController(rootViewController: LoginViewController())
      //        self.window?.rootViewController = navigationController
      //        self.window?.makeKeyAndVisible()
      self.window = UIWindow(windowScene: windowScene)
      let loginVC = LoginViewController()
      let navigationController = UINavigationController(rootViewController: loginVC)
      self.window?.rootViewController = navigationController
      self.window?.makeKeyAndVisible()
      LoginAPI.shared.loginVC = loginVC
   }
   
   func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
      if let url = URLContexts.first?.url {
         if url.absoluteString.starts(with: "copro://") {
            if let code = url.absoluteString.split(separator: "=").last.map({ String($0) }) {
               GitHubLoginManager.shared.requestAccessToken(with: code)
            }
         }
      }
   }
}

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
        self.window = UIWindow(windowScene: windowScene)
        let onBoardingView = OnboardingViewController()
        let navigationController = UINavigationController(rootViewController: onBoardingView)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        //MARK: - 화면 전환 에니메이션
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // 2초 후 이동
            UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseIn, animations: {
                self.window?.rootViewController?.view.alpha = 0.0
            }, completion: { _ in
                //MARK: - 로그인 상태에 따른 화면 전환
                LoginAPI.shared.refreshAccessToken { result in
                    switch result {
                    case .success(let loginDTO):
                        print("토큰 재발급 성공: \(loginDTO)")
                        
                        DispatchQueue.main.async {
                            let bottomtabVC = BottomTabController()
                            bottomtabVC.modalPresentationStyle = .custom
                            bottomtabVC.view.alpha = 0.0
                            bottomtabVC.modalPresentationStyle = .fullScreen

                            self.window?.rootViewController?.present(bottomtabVC, animated: false) {
                                UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut, animations: {
                                    bottomtabVC.view.alpha = 1.0 // fade-in 애니메이션
                                }, completion: nil)
                            }
                        }
                    case .failure(let error):
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .custom
                        loginVC.view.alpha = 0.0
                        loginVC.modalPresentationStyle = .fullScreen
                        
                        self.window?.rootViewController?.present(loginVC, animated: false) {
                            UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut, animations: {
                                loginVC.view.alpha = 1.0 // fade-in 애니메이션
                            }, completion: nil)
                            LoginAPI.shared.loginVC = loginVC
                        }
                    }
                }
               let loginVC = LoginViewController()
               loginVC.modalPresentationStyle = .custom
               loginVC.view.alpha = 0.0
               loginVC.modalPresentationStyle = .fullScreen
               
               self.window?.rootViewController?.present(loginVC, animated: false) {
                   UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut, animations: {
                       loginVC.view.alpha = 1.0 // fade-in 애니메이션
                   }, completion: nil)
                   LoginAPI.shared.loginVC = loginVC
               }
            })
        }
       
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

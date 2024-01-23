//
//  AppDelegate.swift
//  CoPro
//
//  Created by 박신영 on 10/10/23.
//

import UIKit
import Firebase
import FirebaseCore
import GoogleSignIn
import OAuthSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FirebaseApp.configure() // 여기에서 Firebase를 설정합니다.

        let window = UIWindow(frame: UIScreen.main.bounds)
        AppController.shared.show(in: window)
        
        return true
    }
    
    //소셜 로그인 관련
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        } else if let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                  sourceApplication == "com.apple.SafariViewService" {
            let provider = OAuthProvider(providerID: "github.com")
            provider.getCredentialWith(nil) { credential, error in
                print("github Login")
                if let error = error {
                    print("깃허브 로그인 에러: \(error.localizedDescription)")
                    return
                }
                
                guard let credential = credential else {
                    print("Credential is nil")
                    return
                }
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        print("파이어베이스에 로그인 정보 추가 에러: \(error.localizedDescription)")
                    } else {
                        print("Login Successful \n이후 네비게이션은 추후 한 번에 진행")
//                        AppController.shared.checkSignIn() // 로그인 성공 후 checkSignIn 메서드를 호출합니다.
                    }
                }
            }
            return true
        }
        return false
    }

    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

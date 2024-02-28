//
//  AppDelegate.swift
//  CoPro
//
//  Created by 박신영 on 10/10/23.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn
import OAuthSwift
import UserNotifications
import FirebaseAnalytics
import KeychainSwift


@main
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // 파이어베이스 설정
        FirebaseApp.configure()
        
        // 앱 실행 시 사용자에게 알림 허용 권한을 받음
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        // UNUserNotificationCenterDelegate를 구현한 메서드를 실행시킴
        application.registerForRemoteNotifications()
        
        // 파이어베이스 Meesaging 설정
        Messaging.messaging().delegate = self
        
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
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 백그라운드에서 푸시 알림을 탭했을 때 실행
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNS token: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // Foreground(앱 켜진 상태)에서도 알림 오는 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner])
    }
    // 사용자가 알림을 탭했을 때 호출됩니다.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 알림을 탭했을 때의 동작 정의
        if let boardId = response.notification.request.content.userInfo["boardId"] as? String {
            // 특정 뷰 컨트롤러를 표시하는 코드
            let bottomTabController = BottomTabController()
            // 현재 활성화된 UINavigationController의 루트 뷰 컨트롤러로 설정합니다.
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let delegate = windowScene.delegate as? SceneDelegate,
               let window = delegate.window {
                window.rootViewController = bottomTabController
                let detailVC = DetailBoardViewController()
                detailVC.postId = Int(boardId)
                let navigationController = UINavigationController(rootViewController: detailVC)
                navigationController.modalPresentationStyle = .overFullScreen
                window.rootViewController?.present(navigationController, animated: true, completion: nil)
                window.makeKeyAndVisible()
            }
        }
        
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    
    // 파이어베이스 MessagingDelegate 설정
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
       let keychain = KeychainSwift()
      print("Firebase registration token: \(String(describing: fcmToken))")
       guard let fcmToken = fcmToken else {return print("fcmToken 설정 에러")}
       keychain.set(fcmToken, forKey: "FcmToken")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

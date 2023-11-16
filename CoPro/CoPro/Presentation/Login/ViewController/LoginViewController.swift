//
//  LoginViewController.swift
//  CoPro
//
//  Created by 박현렬 on 11/8/23.
//

import UIKit
import Firebase
import GoogleSignIn
import AuthenticationServices
import OAuthSwift
import SnapKit
import SafariServices
import Alamofire
import KeychainSwift

class LoginViewController: UIViewController {
    
    var loginView: LoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // LoginView를 생성하고 뷰에 추가합니다.
        loginView = LoginView(frame: view.bounds)
        view.backgroundColor = .white
        view.addSubview(loginView)
        
        // Google 로그인 버튼
        loginView.googleSignInButton.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
        
        // Apple 로그인 버튼
        loginView.appleSignInButton.addTarget(self, action: #selector(handleAppleSignIn), for: .touchUpInside)
        
        // GitHub 로그인 버튼
        loginView.githubSignInButton.addTarget(self, action: #selector(handleGitHubSignIn), for: .touchUpInside)
        
        loginView.signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
    }
    @objc func signOut() {
        if Auth.auth().currentUser != nil{
            do {
                try Auth.auth().signOut()
                // 로그아웃이 성공적으로 처리된 후의 코드를 여기에 작성합니다.
                // 예를 들어, 로그인 화면으로 돌아가는 등의 처리를 할 수 있습니다.
                print("로그아웃")
                self.navigationController?.popToRootViewController(animated: true)
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
        else{
            print("로그인 된 계정없음")
        }
    }
    
    @objc func handleGoogleSignIn() {
        print("Google Sign in button tapped")
        
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let user = signInResult?.user,
                  let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().addStateDidChangeListener { (auth, user) in
                if let user = user {
                    // 사용자가 로그인한 상태
                    print("User \(user.uid) is signed in.")
                } else {
                    // 사용자가 로그아웃한 상태
                    print("User is not signed in.")
                }
            }
            //파이어베이스에 로그인 정보 추가
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Login Successful")
                    
                    Auth.auth().currentUser?.getIDTokenResult { idTokenResult, error in
                        if let error = error {
                            print("Error fetching ID token: \(error)")
                            return
                        }
                        guard let idToken = idTokenResult?.token else {
                            print("User doesn't have an ID token.")
                            return
                        }
                        print("User ID token: \(idToken)!!!")
                    }
                }
            }
            
            
        }
        
    }
    
    @objc func handleAppleSignIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    class gitHubLoginManager {
        
        static let shared = gitHubLoginManager()
        
        private init() {}
        
        private let client_id = "e0abaf8660ab93c1bfe3"
        private let client_secret = "5cb9c1c6cc62951b4b266f9fc725d9fff78871c8"
        
        func requestCode() {
            let scope = "read:user"
            let urlString = "https://github.com/login/oauth/authorize?client_id=\(client_id)&scope=\(scope)"
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print(urlString)
            }
//            let safariViewController = SFSafariViewController(url: urlString)
//            self.present(safariViewController, animated: true, completion: nil)
        }
        
        func requestAccessToken(with code: String) {
            let url = "https://github.com/login/oauth/access_token"
            
            let parameters = ["client_id": client_id,
                              "client_secret": client_secret,
                              "code": code]
            
            let headers: HTTPHeaders = ["Accept": "application/json"]
            
            AF.request(url, method: .post, parameters: parameters, headers: headers).responseJSON { (response) in
                switch response.result {
                case let .success(json):
                    if let dic = json as? [String: String] {
                        let accessToken = dic["access_token"] ?? ""
                        KeychainSwift().set(accessToken, forKey: "accessToken")
                    }
                case let .failure(error):
                    print(error)
                }
            }
        }
        
        func logout() {
            KeychainSwift().clear()
        }
    }
    @objc func handleGitHubSignIn() {
        gitHubLoginManager.shared.requestCode()
    }
    
    
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    //    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    //        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
    //            let credential = OAuthProvider.credential(withProviderID: "apple.com",
    //                                                      idToken: String(data: appleIDCredential.identityToken!, encoding: .utf8)!,
    //                                                      rawNonce: nonce)
    //            Auth.auth().signIn(with: credential) { (authResult, error) in
    //                if let error = error {
    //                    print("Failed to sign in with Apple: ", error)
    //                    return
    //                }
    //                // User is signed in
    //                // ...
    //            }
    //        }
    //    }
    //
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error
        print("Sign in with Apple errored: ", error)
    }
}

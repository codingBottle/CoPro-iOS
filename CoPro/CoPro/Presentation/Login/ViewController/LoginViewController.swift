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
    
    @objc func handleGitHubSignIn() {
        let url = URL(string: "https://github.com/login/oauth/authorize?client_id=YOUR_CLIENT_ID&scope=read:user")!
        UIApplication.shared.open(url)
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

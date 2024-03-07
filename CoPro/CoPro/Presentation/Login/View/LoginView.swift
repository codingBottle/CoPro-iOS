//
//  LoginView.swift
//  CoPro
//
//  Created by 박현렬 on 11/8/23.
//

import UIKit
import SnapKit
import Then
import GoogleSignIn
import AuthenticationServices

protocol LoginViewDelegate: AnyObject {
    func handleAppleIDRequest()
    func handleGitHubSignIn()
}

class LoginView: BaseView {
    weak var delegate: LoginViewDelegate?
    //loginButton 선언
    let signOutButton = UIButton()
    //SigninLogo&Label
    let coproLogo = UIImageView(image : Image.coproLogo)
    let coproLogoLabel = UILabel().then{
        $0.setPretendardFont(text: "협업할 개발자를 찾는다면?", size: 25.0, weight: .bold, letterSpacing: 1.37)
        $0.textAlignment = .center
    }
    //appleSignInButton
    let appleSignInButton = UIButton()
    let appleLogo = UIImageView(image:Image.apple_SignInButton)
    let appleSignInTitle = UILabel().then{
        $0.setPretendardFont(text: "Sign in with Apple", size: 17.0, weight: .regular, letterSpacing: 1.23)
        $0.textAlignment = .center
        $0.textColor = UIColor.White()
    }
    //GoogleSignInButton
    let googleSignInButton = UIButton()
    let googleLogo = UIImageView(image:Image.google_SignInButton)
    let googleLogoBackGround = UIView()
    let googleSignInTitle = UILabel().then{
        $0.setPretendardFont(text: "Sign in with Google", size: 17.0, weight: .regular, letterSpacing: 1.23)
        $0.textAlignment = .center
        $0.textColor = UIColor.White()
    }
    //GitHubSignInButton
    let githubSignInButton = UIButton()
    let githubLogo = UIImageView(image:Image.github_SignInButton)
    let githubSignInTitle = UILabel().then{
        $0.setPretendardFont(text: "Sign in with GitHub", size: 17.0, weight: .regular, letterSpacing: 1.23)
        $0.textAlignment = .center
        $0.textColor = UIColor.White()
    }
    
    
    
    override func setUI() {
        addSubview(coproLogo)
        addSubview(googleSignInButton)
        addSubview(appleSignInButton)
        addSubview(githubSignInButton)
        addSubview(signOutButton)
        //Copro Label Design
        addSubview(coproLogoLabel)

        //AppleSignInButton
        appleSignInButton.addSubview(appleLogo)
        appleSignInButton.addSubview(appleSignInTitle)
        
        //GoogleSignInButton
        googleSignInButton.addSubview(googleLogoBackGround)
        googleLogoBackGround.addSubview(googleLogo)
        googleSignInButton.addSubview(googleSignInTitle)
        //GitHubSignInButton
        githubSignInButton.addSubview(githubLogo)
        githubSignInButton.addSubview(githubSignInTitle)

        
    }
    override func setLayout() {
        coproLogoLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
            $0.bottom.equalTo(coproLogo.snp.top).offset(-20)  // logo 위에 위치
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        //Logo Design
        coproLogo.snp.makeConstraints{
            $0.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
            $0.centerY.equalTo(self.safeAreaLayoutGuide.snp.centerY).offset(-82)
            $0.width.equalTo(192)
            $0.height.equalTo(177)
        }
        appleLogo.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.width.equalTo(17)
            $0.height.equalTo(20)
        }
        
        appleSignInTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        appleSignInButton.snp.makeConstraints {
            $0.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
            $0.top.equalTo(coproLogo.snp.bottom).offset(42)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.height.equalTo(48)
        }
        
        appleSignInButton.backgroundColor = UIColor.black
        appleSignInButton.layer.cornerRadius = 12
        googleLogo.snp.makeConstraints {
            $0.width.height.equalTo(17)
            $0.centerX.centerY.equalToSuperview()
        }
        googleLogoBackGround.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.width.height.equalTo(20)
        }
        googleLogoBackGround.backgroundColor = .white
        googleLogoBackGround.layer.cornerRadius = 10
        googleLogoBackGround.clipsToBounds = true
        
        googleSignInTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        googleSignInButton.snp.makeConstraints {
            $0.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
            $0.top.equalTo(appleSignInButton.snp.bottom).offset(20)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.height.equalTo(48)
        }
        googleSignInButton.backgroundColor = UIColor(red: 0.25, green: 0.52, blue: 0.95, alpha: 1.0)
        googleSignInButton.layer.cornerRadius = 12
        githubLogo.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.width.height.equalTo(20)
        }
        //        githubLogo.backgroundColor = .white
        githubLogo.layer.cornerRadius = 10
        githubLogo.clipsToBounds = true
        
        githubSignInTitle.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        githubSignInButton.snp.makeConstraints {
            $0.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
            $0.top.equalTo(googleSignInButton.snp.bottom).offset(20)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.height.equalTo(48)
        }
        githubSignInButton.backgroundColor = UIColor.black
        githubSignInButton.layer.cornerRadius = 12
        
    }
    
    @objc func didTapAppleSignIn() {
        delegate?.handleAppleIDRequest()
    }
    
}


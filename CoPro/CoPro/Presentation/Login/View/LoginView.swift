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

class LoginView: UIView {
    weak var delegate: LoginViewDelegate?
    //loginButton 선언
    let googleSignInButton = UIButton()
    let appleSignInButton = UIButton()
    let githubSignInButton = UIButton()
    let signOutButton = UIButton()
    let coproLogo = UIImageView(image : Image.coproLogo)
    let coproLogoLabel = UILabel()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //view에 button추가
        addSubview(coproLogo)
        addSubview(googleSignInButton)
        addSubview(appleSignInButton)
        addSubview(githubSignInButton)
        addSubview(signOutButton)
        
        addSubview(coproLogoLabel)
        let attributedString = NSMutableAttributedString(string: "협업할 개발자를 찾는다면?", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold)])
        attributedString.addAttribute(NSAttributedString.Key.kern, value: 1.37, range: NSRange(location: 0, length: attributedString.length))

        coproLogoLabel.attributedText = attributedString
        coproLogoLabel.textAlignment = .center
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
        
        //AppleSignInButton Design
        let appleLogo = UIImageView(image:Image.apple_SignInButton)
        let appleSignInTitle = UILabel()
        appleSignInTitle.attributedText = NSAttributedString(string: "Sign in with Apple", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.kern: 1.25])
        appleSignInButton.addSubview(appleLogo)
        appleSignInButton.addSubview(appleSignInTitle)
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

        //GoogleSignInButton Design
        let googleLogo = UIImageView(image:Image.google_SignInButton)
        let googleLogoBackGround = UIView()
        let googleSignInTitle = UILabel()
        googleSignInTitle.attributedText = NSAttributedString(string: "Sign in with Google", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.kern: 1.25])
        googleSignInButton.addSubview(googleLogoBackGround)
        googleLogoBackGround.addSubview(googleLogo)
        googleSignInButton.addSubview(googleSignInTitle)
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
        
        //GitHubSignInButton Design
        let githubLogo = UIImageView(image:Image.github_SignInButton)
        let githubSignInTitle = UILabel()
        githubSignInTitle.attributedText = NSAttributedString(string: "Sign in with GitHub", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.kern: 1.25])
        githubSignInButton.addSubview(githubLogo)
        githubSignInButton.addSubview(githubSignInTitle)
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
        githubSignInButton.setAttributedTitle(NSAttributedString(string: "Sign in with GitHub", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.kern: 1.25]), for: .normal)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapAppleSignIn() {
        delegate?.handleAppleIDRequest()
    }
    
}


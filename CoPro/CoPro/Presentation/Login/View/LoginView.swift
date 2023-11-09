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
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //view에 button추가
        addSubview(googleSignInButton)
        addSubview(appleSignInButton)
        addSubview(githubSignInButton)
        
        //Button Design
        appleSignInButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
            make.centerY.equalTo(self.safeAreaLayoutGuide.snp.centerY)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        appleSignInButton.backgroundColor = UIColor.black
        appleSignInButton.layer.cornerRadius = 12
        appleSignInButton.setAttributedTitle(NSAttributedString(string: "Sign in with Apple", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium),NSAttributedString.Key.foregroundColor: UIColor.white]), for: .normal)
        
        googleSignInButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
            make.top.equalTo(appleSignInButton.snp.bottom).offset(20)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        googleSignInButton.backgroundColor = UIColor(red: 0.25, green: 0.52, blue: 0.95, alpha: 1.0)
        googleSignInButton.layer.cornerRadius = 12
        googleSignInButton.setAttributedTitle(NSAttributedString(string: "Sign in with Google", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium),NSAttributedString.Key.foregroundColor: UIColor.white]), for: .normal)
        
        
        
        githubSignInButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
            make.top.equalTo(googleSignInButton.snp.bottom).offset(20)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        githubSignInButton.backgroundColor = UIColor.black
        githubSignInButton.layer.cornerRadius = 12
        githubSignInButton.setAttributedTitle(NSAttributedString(string: "Sign in with GitHub", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium),NSAttributedString.Key.foregroundColor: UIColor.white]), for: .normal)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapAppleSignIn() {
        delegate?.handleAppleIDRequest()
    }
    
}


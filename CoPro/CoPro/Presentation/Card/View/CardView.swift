//
//  CardView.swift
//  CoPro
//
//  Created by 박현렬 on 11/29/23.
//

import UIKit
import SnapKit
import Then


class CardView: BaseView {
    // UIStackView 생성
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal  // 가로 방향으로 정렬
        $0.distribution = .fillEqually  // 모든 뷰의 크기를 동일하게 설정
        $0.spacing = 20  // 뷰 사이의 간격을 20으로 설정
    }
    let partContainerView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.24)
        $0.layer.cornerRadius = 20
    }
    let partLabel = UILabel().then {
        $0.textAlignment = .left
        $0.attributedText = NSAttributedString(string: "직군", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor(red: 0.581, green: 0.585, blue: 0.596, alpha: 1), NSAttributedString.Key.kern: 1.25])
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
    }
    let partButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        $0.tintColor = UIColor(red: 0.581, green: 0.585, blue: 0.596, alpha: 1)
    }
    let langContainerView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.24)
        $0.layer.cornerRadius = 20
    }
    let langLabel = UILabel().then {
        $0.textAlignment = .left
        $0.attributedText = NSAttributedString(string: "언어", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor(red: 0.581, green: 0.585, blue: 0.596, alpha: 1), NSAttributedString.Key.kern: 1.25])
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
    }
    let langButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        $0.tintColor = UIColor(red: 0.581, green: 0.585, blue: 0.596, alpha: 1)
    }
    let oldContainerView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.24)
        $0.layer.cornerRadius = 20
    }
    let oldLabel = UILabel().then {
        $0.textAlignment = .left
        $0.attributedText = NSAttributedString(string: "경력", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor(red: 0.581, green: 0.585, blue: 0.596, alpha: 1), NSAttributedString.Key.kern: 1.25])
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
    }
    let oldButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        $0.tintColor = UIColor(red: 0.581, green: 0.585, blue: 0.596, alpha: 1)
    }
    let slideCardView = UIView().then{
        $0.backgroundColor = UIColor(red: 0.71, green: 0.769, blue: 0.866, alpha: 1)
        $0.layer.cornerRadius = 30
    }
    let cardImage = UIImageView().then{
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 30
    }
    let chatButton = UIButton().then{
        $0.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        $0.layer.cornerRadius = 15
    }
    let chatLabel = UILabel().then{
        $0.textAlignment = .center
        $0.attributedText = NSAttributedString(string: "채팅하기", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.kern: 1.25])
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
    }
    let infoView = UIView().then{
        $0.backgroundColor = UIColor.white
    }
    let infoTextStackView = UIStackView()
    let userNameLabel = UILabel()
    let userPartLabel = UILabel()
    let userLangLabel = UILabel()
    let infoIconStackView = UIStackView()
    let likeIcon = UIImage()
//    let gitIcon = UIButton().then{
//        $0.setImage(gitImage, for: .normal)
//    }
//    let gitImage = UIImage(image:Image.github_SignInButton)

    
    
    override func setUI() {
        addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(partContainerView)
        buttonStackView.addArrangedSubview(langContainerView)
        buttonStackView.addArrangedSubview(oldContainerView)
        partContainerView.addSubviews(partLabel,partButton)
        langContainerView.addSubviews(langLabel,langButton)
        oldContainerView.addSubviews(oldLabel,oldButton)
        addSubview(slideCardView)
        slideCardView.addSubview(cardImage)
        slideCardView.addSubview(chatButton)
        chatButton.addSubview(chatLabel)
        slideCardView.addSubview(infoView)
    }
    
    override func setLayout() {
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.centerX.equalTo(self.safeAreaLayoutGuide)
            $0.width.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }
        partLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        partButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.trailing.equalTo(partLabel.snp.trailing).offset(20)
            $0.centerY.equalToSuperview()
        }
        langLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        langButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.trailing.equalTo(langLabel.snp.trailing).offset(20)
            $0.centerY.equalToSuperview()
        }
        oldLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        oldButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.trailing.equalTo(oldLabel.snp.trailing).offset(20)
            $0.centerY.equalToSuperview()
        }
        slideCardView.snp.makeConstraints{
            $0.top.equalTo(buttonStackView.snp.bottom).offset(20)
            $0.centerX.equalTo(self.safeAreaLayoutGuide)
            $0.width.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(100)
        }
        cardImage.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.width.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(200)
        }
        chatButton.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
            $0.width.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        chatLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        infoView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cardImage.snp.bottom).offset(10)
            $0.bottom.equalTo(chatButton.snp.top).offset(-10)
            $0.width.equalToSuperview().inset(20)
        }
    }
}

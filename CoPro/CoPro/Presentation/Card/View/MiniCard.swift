//
//  MiniCard.swift
//  CoPro
//
//  Created by 박현렬 on 1/8/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class MiniCard: BaseView {
    let profileArea = UIView().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    let profile = UIImageView().then{
        $0.layer.cornerRadius = 80/2
        $0.clipsToBounds = true
    }
    func loadImage(url: String) {
        guard !url.isEmpty, let imageURL = URL(string: url) else {
            // URL이 빈 문자열일 때의 처리 (예: 빨간색 배경)
            profile.backgroundColor = .red
            return
        }
        profile.kf.indicatorType = .activity
        profile.kf.setImage(
            with: imageURL,
            placeholder: nil,
            options: [
                .transition(.fade(1.0)),
                .forceTransition,
                .cacheOriginalImage,
                .scaleFactor(UIScreen.main.scale), // 이미지 스케일 지정
                
            ],
            completionHandler: nil
        )
    }
    
    let userNameLabel = UILabel().then {
        $0.textColor = UIColor.G3()
        $0.textAlignment = .center
        $0.setPretendardFont(text: "", size: 9, weight: .regular, letterSpacing: 1.0)
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = .lightGray
        $0.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    let infoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 1
        $0.alignment = .center
    }
    
    let userPartLabel = UILabel().then {
        $0.textAlignment = .center
        $0.setPretendardFont(text: "", size: 17, weight: .bold, letterSpacing: 1.0)
        $0.textColor = UIColor.Black()
    }
    
    let userLangLabel = UILabel().then {
        $0.textAlignment = .center
        $0.setPretendardFont(text: "", size: 17, weight: .bold, letterSpacing: 1.23)
        $0.textColor = UIColor.Black()
    }
    
    let userCareerLabel = UILabel().then {
        $0.textAlignment = .center
        $0.setPretendardFont(text: "hi", size: 11, weight: .regular, letterSpacing: 1.0)
        $0.textColor = UIColor.Black()
    }
    
    let buttonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 5
        $0.alignment = .center
    }
    
    let chatButton = UIButton().then {
        $0.backgroundColor =  UIColor.P7()
        $0.layer.cornerRadius = 8
    }
    
    let chatLabel = UILabel().then {
        $0.textAlignment = .center
        $0.setPretendardFont(text: "채팅하기", size: 8, weight: .regular, letterSpacing: 1.15)
        $0.textColor = UIColor.Black()
    }
    
    let gitButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let gitImage = UIImage(named: "github_SignInButton")?.withRenderingMode(.alwaysTemplate)
        var container = AttributeContainer()
        
        container.font = .systemFont(ofSize: 8, weight: .regular)
        let resizedImage = gitImage?.resized(to: CGSize(width: 16, height: 16)) // 이미지 크기 조절
        
        config.imagePadding = 5
        config.imagePlacement = .leading
        config.attributedTitle = AttributedString("Git", attributes: container)
        config.image = resizedImage
        config.baseForegroundColor = .black
        
        let button = UIButton(configuration: config)
        
        button.backgroundColor =  UIColor.P7()
        button.layer.cornerRadius = 8
        
        return button
    }()

    let likeIcon = UIButton().then {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .large)
        let largeBoldDoc = UIImage(systemName: "suit.heart.fill", withConfiguration: largeConfig)
        $0.setImage(largeBoldDoc, for: .normal)
    }
    
    // 하트 갯수를 나타내는 레이블
    let likeLabel = UILabel().then {
        $0.textAlignment = .center
        $0.setPretendardFont(text: "", size: 12, weight: .regular, letterSpacing: 1.0)
    }
    
    
    override func setUI() {
        addSubviews(profileArea,profile, userNameLabel, lineView, infoStackView )
        infoStackView.addArrangedSubviews(userPartLabel,userLangLabel,userCareerLabel)
        addSubviews(buttonStackView)
        buttonStackView.addArrangedSubviews( gitButton,chatButton)
        chatButton.addSubview(chatLabel)
        addSubview(likeIcon)
        addSubview(likeLabel)
        
        layer.do {
            $0.cornerRadius = 15
            $0.borderWidth = 1
            $0.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        }
    }
    
    override func setLayout() {
        likeIcon.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(12)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-12)
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        }
        
        likeLabel.snp.makeConstraints {
            $0.top.equalTo(likeIcon.snp.bottom).offset(-2)
            $0.trailing.equalTo(likeIcon.snp.trailing)
            $0.width.greaterThanOrEqualTo(20)
            $0.centerX.equalTo(likeIcon.snp.centerX)
        }
        profileArea.snp.makeConstraints{
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(12)
            //            $0.centerX.equalToSuperview()
            $0.height.equalTo(80)
            $0.width.equalTo(80)
        }
        profile.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(80)
            $0.width.equalTo(80)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(profile.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
            $0.height.greaterThanOrEqualTo(11)
        }
        userNameLabel.setContentHuggingPriority(.required, for: .vertical)
        userNameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        lineView.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(3)
        }
        
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        userCareerLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
        }
        buttonStackView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(infoStackView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().offset(-12)
            $0.width.equalToSuperview().inset(20)
        }
        gitButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
        }
        chatButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
        }
        chatLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let layer1 = layer.sublayers?.first {
            layer1.bounds = bounds
            layer1.position = center
        }
    }
}

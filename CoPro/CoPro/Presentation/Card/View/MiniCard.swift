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
            guard let imageURL = URL(string: url) else { return }

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
        $0.textColor = UIColor(red: 0.581, green: 0.585, blue: 0.596, alpha: 1)
        $0.textAlignment = .center
        $0.attributedText = NSAttributedString(string: "name", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 9, weight: .regular)])
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = .lightGray
        $0.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    let infoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 1
        $0.alignment = .center
    }
    
    let userPartLabel = UILabel().then {
        $0.textAlignment = .center
        $0.attributedText = NSAttributedString(string: "Mobile", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.kern: 0.84])
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
    }
    
    let userLangLabel = UILabel().then {
        $0.textAlignment = .center
        $0.attributedText = NSAttributedString(string: "Swift / Dart", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.kern: 1.23])
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
    }
    
    let userCareerLabel = UILabel().then {
        $0.textAlignment = .center
        $0.attributedText = NSAttributedString(string: "~6개월", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.kern: 0.95])
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
    }
    
    let buttonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 5
        $0.alignment = .center
    }
    
    let chatButton = UIButton().then {
        $0.backgroundColor =  UIColor(red: 0.71, green: 0.769, blue: 0.866, alpha: 1)
        $0.layer.cornerRadius = 8
    }
    
    let chatLabel = UILabel().then {
        $0.textAlignment = .center
        $0.attributedText = NSAttributedString(string: "채팅하기", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 8, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.kern: 1.15])
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
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
        
        button.backgroundColor =  UIColor(red: 0.71, green: 0.769, blue: 0.866, alpha: 1)
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    override func setUI() {
        addSubviews(profileArea,profile, userNameLabel, lineView, infoStackView )
        infoStackView.addArrangedSubviews(userPartLabel,userLangLabel,userCareerLabel)
        addSubviews(buttonStackView)
        buttonStackView.addArrangedSubviews(chatButton, gitButton)
        chatButton.addSubview(chatLabel)

        layer.do {
            $0.cornerRadius = 15
            $0.borderWidth = 1
            $0.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        }
    }
    
    override func setLayout() {
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

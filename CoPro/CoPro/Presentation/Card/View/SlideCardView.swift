//
//  SlideCardView.swift
//  CoPro
//
//  Created by 박현렬 on 1/1/24.
//

import UIKit
import SnapKit
import Then

class SlideCardView: BaseView {
    let cardView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.71, green: 0.769, blue: 0.866, alpha: 1)
        $0.layer.cornerRadius = 30
    }
    let cardImage = UIImageView().then {
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 30
    }
    let cardbuttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 20
    }
    let chatButton = UIButton().then {
        $0.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        $0.layer.cornerRadius = 15
    }
    let chatLabel = UILabel().then {
        $0.textAlignment = .center
        $0.attributedText = NSAttributedString(string: "채팅하기", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.kern: 1.25])
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
    }
    let gitImage = UIImageView(image: Image.github_SignInButton)
    let gitButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 1
        $0.alignment = .center
    }
    
    let gitButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let gitImage = UIImage(named: "github_SignInButton")?.withRenderingMode(.alwaysTemplate)
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 16, weight: .regular)
        let resizedImage = gitImage?.resized(to: CGSize(width: 32, height: 32)) // 이미지 크기 조절
        
        // 이미지와 텍스트 간 여백 설정
        config.imagePadding = 5 // 이미지 여백
        config.imagePlacement = .leading // 이미지 위치
        config.attributedTitle = AttributedString("Git", attributes: container)
        config.image = resizedImage
        config.baseForegroundColor = .black
        
        let button = UIButton(configuration: config)
        
        button.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        button.layer.cornerRadius = 15
        
        return button
    }()
    let infoView = UIView()
    let infoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 8
        $0.alignment = .leading
    }
    let userNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.attributedText = NSAttributedString(string: "개발자 사나이", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.kern: 1.21])
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
    }
    let userPartLabel = UILabel().then {
        $0.textAlignment = .center
        $0.attributedText = NSAttributedString(string: "Mobile", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.kern: 1.37])
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
    }
    let userLangLabel = UILabel().then {
        $0.textAlignment = .center
        $0.attributedText = NSAttributedString(string: "Swift / Dart", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.kern: 1.37])
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
    }
    let infoIconStackView = UIStackView()
    let likeIcon = UIImageView().then {
        $0.image = UIImage(systemName: "heart")
        $0.contentMode = .scaleAspectFit
    }
    
    override func setUI() {
        addSubview(cardView)
        cardView.addSubview(cardImage)
        cardView.addSubview(cardbuttonStackView)
        cardbuttonStackView.addArrangedSubview(gitButton)
        cardbuttonStackView.addArrangedSubview(chatButton)
        chatButton.addSubview(chatLabel)
        cardView.addSubview(infoView)
        infoView.addSubview(infoStackView)
        infoStackView.addArrangedSubviews(userNameLabel,userPartLabel,userLangLabel)
        
        infoView.addSubview(likeIcon)
    }
    
    override func setLayout() {
        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        cardImage.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.width.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(200)
        }
        infoView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cardImage.snp.bottom).offset(10)
            $0.bottom.equalTo(chatButton.snp.top).offset(-10)
            $0.width.equalToSuperview().inset(20)
        }
        infoStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        likeIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(35)
        }
        cardbuttonStackView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
            $0.width.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        chatButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
        }
        gitButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            
        }
        chatLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        
    }
}

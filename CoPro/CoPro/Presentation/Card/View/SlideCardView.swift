//
//  SlideCardView.swift
//  CoPro
//
//  Created by 박현렬 on 1/1/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class SlideCardView: BaseView {
    let imageUrl = UILabel().then{
        $0.text = ""
    }
    func loadImage(url: String) {
        guard !url.isEmpty, let imageURL = URL(string: url) else {
            // URL이 빈 문자열일 때의 처리 (예: 빨간색 배경)
            cardImage.backgroundColor = .red
            return
        }
        cardImage.kf.indicatorType = .activity
        cardImage.kf.setImage(
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
    let cardView = UIView().then {
        $0.backgroundColor = UIColor.P7()
        $0.layer.cornerRadius = 30
    }
    let cardImage = UIImageView().then{
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
    }
    let cardbuttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 20
    }
    let chatButton = UIButton().then {
        $0.backgroundColor = UIColor.White(alpha: 0.5)
        $0.layer.cornerRadius = 15
    }
    let chatLabel = UILabel().then {
        $0.textAlignment = .center
        $0.setPretendardFont(text: "채팅하기", size: 16, weight: .regular, letterSpacing: 1.15)
        $0.textColor = UIColor.Black()
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
        
        button.backgroundColor = UIColor.White(alpha: 0.5)
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
        $0.setPretendardFont(text: "", size: 14, weight: .regular, letterSpacing: 1.26)
        $0.textColor = UIColor.Black()
    }
    let userPartLabel = UILabel().then {
        $0.textAlignment = .center
        $0.setPretendardFont(text: "", size: 25, weight: .bold, letterSpacing: 1.24)
        $0.textColor = UIColor.Black()
    }
    let userLangLabel = UILabel().then {
        $0.textAlignment = .center
        $0.setPretendardFont(text: "", size: 25, weight: .bold, letterSpacing: 1.24)
        $0.textColor = UIColor.Black()
    }
    let infoIconStackView = UIStackView().then{
        $0.axis = .vertical
        $0.distribution = .equalCentering
        $0.spacing = 2
    }
    let likeIcon = UIImageView().then {
        $0.image = UIImage(systemName: "suit.heart.fill")
        $0.tintColor = UIColor.G1()
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = true
//        $0.sizeToFit()
    }
    let likeLabel = UILabel().then{
        $0.setPretendardFont(text: "", size: 16, weight: .regular, letterSpacing: 1.15)
        $0.textColor = UIColor.White()
        $0.textAlignment = .center
    }
    override init() {
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        infoView.addSubview(infoIconStackView)
        infoIconStackView.addArrangedSubviews(likeIcon,likeLabel)
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
            $0.centerY.equalToSuperview()
        }
        
        infoIconStackView.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.top.equalTo(cardImage.snp.bottom).offset(10)
        }
        likeIcon.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        likeLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
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

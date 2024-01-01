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
    let cardbuttonStackView = UIStackView().then {
        $0.axis = .horizontal  // 가로 방향으로 정렬
        $0.distribution = .fillEqually  // 모든 뷰의 크기를 동일하게 설정
        $0.spacing = 20  // 뷰 사이의 간격을 20으로 설정
    }
    let cardButtonStackView = UIStackView().then {
        $0.axis = .horizontal  // 가로 방향으로 정렬
        $0.distribution = .fillEqually  // 모든 뷰의 크기를 동일하게 설정
        $0.spacing = 20  // 뷰 사이의 간격을 20으로 설정
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


    let gitLabel = UILabel().then{
        $0.textAlignment = .center
        $0.attributedText = NSAttributedString(string: "Git", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.kern: 1.25])
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
    }
    let gitButtonStack = UIStackView().then{
        $0.axis = .horizontal
        $0.spacing = 1
        $0.alignment = .center
    }
    let infoView = UIView()
    let infoStackView = UIStackView().then{
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 8
        $0.alignment = .leading
    }
    let userNameLabel = UILabel().then{
        $0.textAlignment = .center
        $0.attributedText = NSAttributedString(string: "개발자 사나이", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.kern: 1.21])
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
    }
    let userPartLabel = UILabel().then{
        $0.textAlignment = .center
        $0.attributedText = NSAttributedString(string: "Mobile", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.kern: 1.37])
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
    }
    let userLangLabel = UILabel().then{
        $0.textAlignment = .center
        $0.attributedText = NSAttributedString(string: "Swift / Dart", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.kern: 1.37])
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.7
    }
    let infoIconStackView = UIStackView()
    let likeIcon = UIImageView().then{
        $0.image = UIImage(systemName: "heart")
        $0.contentMode = .scaleAspectFit
    }
    let gitImage = UIImageView(image:Image.github_SignInButton)
    let scrollView = UIScrollView().then {
        $0.isPagingEnabled = true
    }
    
    
    override func setUI() {
        addSubview(buttonStackView)
        buttonStackView.addArrangedSubviews(partContainerView,langContainerView,oldContainerView)
        partContainerView.addSubviews(partLabel,partButton)
        langContainerView.addSubviews(langLabel,langButton)
        oldContainerView.addSubviews(oldLabel,oldButton)
        addSubview(slideCardView)
        slideCardView.addSubview(cardImage)
        slideCardView.addSubview(cardbuttonStackView)
        cardbuttonStackView.addArrangedSubview(gitButton)
        cardbuttonStackView.addArrangedSubview(chatButton)
        chatButton.addSubview(chatLabel)
        slideCardView.addSubview(infoView)
        infoView.addSubview(infoStackView)
        infoStackView.addArrangedSubviews(userNameLabel,userPartLabel,userLangLabel)
        
        infoView.addSubview(likeIcon)
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
extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

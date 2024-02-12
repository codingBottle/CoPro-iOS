//
//  ProfileImageTableViewCell.swift
//  CoPro
//
//  Created by 박신영 on 1/12/24.
//

import UIKit
import SnapKit
import Then

protocol EditProfileButtonDelegate: AnyObject {
    func didTapEditProfileButton(in cell: ProfileImageTableViewCell)
}

class ProfileImageTableViewCell: UITableViewCell {
    
    weak var delegate: EditProfileButtonDelegate?
    
    let containerView = UIView()
    let profileImage = UIImageView(image : Image.coproLogo)
    let informationContainer = UIView()
    
    let nickname: UILabel = {
        let label = UILabel()
        label.text = "테스트"
        return label
    }()
    
    let developmentJobLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트"
        return label
    }()
    
    let usedLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트"
        return label
    }()
    
    let buttonContainerView = UIView().then {
        $0.layer.backgroundColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.2).cgColor
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 25 // 반지름은 너비의 절반으로 설정합니다.
    }
    
    var editButton = UIButton().then {
        let symbolConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "square.and.pencil", withConfiguration: symbolConfiguration)
        
        var buttonConfiguration = UIButton.Configuration.gray()
        buttonConfiguration.image = image
        buttonConfiguration.imagePadding = 10
        buttonConfiguration.background.backgroundColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.2)
        buttonConfiguration.cornerStyle = .capsule
        $0.configuration = buttonConfiguration
    }



    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        selectedBackgroundView = UIView()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        
        contentView.addSubview(containerView)
        containerView.addSubview(profileImage)
        profileImage.addSubview(informationContainer)
        informationContainer.addSubviews(nickname, developmentJobLabel, usedLanguageLabel, editButton)
//        buttonContainerView.addSubview(editButton)
        
        profileImage.isUserInteractionEnabled = true
        editButton.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        profileImage.do {
            $0.layer.borderColor = UIColor.green.cgColor
            $0.layer.borderWidth = 1
        }
        
        profileImage.snp.makeConstraints {
            $0.edges.equalTo(containerView.layoutMarginsGuide)
        }
        
        informationContainer.do {
            $0.layer.borderColor = UIColor.red.cgColor
            $0.layer.borderWidth = 1
        }
        
        informationContainer.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(profileImage.snp.height).multipliedBy(0.28)
        }
        
        nickname.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(informationContainer.snp.width).multipliedBy(0.3)
        }
        
        developmentJobLabel.snp.makeConstraints {
            $0.top.equalTo(nickname.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.width.equalTo(informationContainer.snp.width).multipliedBy(0.13)
        }
        
        usedLanguageLabel.snp.makeConstraints {
            $0.top.equalTo(developmentJobLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.width.equalTo(informationContainer.snp.width).multipliedBy(0.4)
        }
        
        
        editButton.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
//        editButton.snp.makeConstraints {
//            $0.leading.trailing.top.bottom.equalToSuperview()
//        }
    }
    
    @objc func didTapEditProfileButton(_ sender: UIButton) {
        print("🌊🌊🌊🌊🌊🌊🌊🌊🌊🌊🌊🌊🌊🌊🌊🌊🌊🌊🌊")
        delegate?.didTapEditProfileButton(in: self)
    }
    
}

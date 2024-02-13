//
//  ProfileImageTableViewCell.swift
//  CoPro
//
//  Created by 박신영 on 1/12/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

protocol EditProfileButtonDelegate: AnyObject {
    func didTapEditProfileButton(in cell: ProfileImageTableViewCell)
}

class ProfileImageTableViewCell: UITableViewCell {
    
    weak var delegate: EditProfileButtonDelegate?
    
    let containerView = UIView()
    let profileImage = UIImageView().then{
        $0.clipsToBounds = true
    }
    let informationContainer = UIView()
    
    let nickname = UILabel().then {
        $0.setPretendardFont(text: "테스트", size: 34, weight: .bold, letterSpacing: 1.23)
        $0.textColor = UIColor.White()
    }
    
    let developmentJobLabel = UILabel().then {
        $0.setPretendardFont(text: "테스트", size: 26, weight: .medium, letterSpacing: 1.23)
        $0.textColor = UIColor.White()
    }
    
    let usedLanguageLabel = UILabel().then {
        $0.setPretendardFont(text: "테스트", size: 26, weight: .medium, letterSpacing: 1.23)
        $0.textColor = UIColor.White()
    }
    
    let buttonContainerView = UIView().then {
        $0.layer.backgroundColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.2).cgColor
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 25
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
    
    let imageUrl = UILabel().then{
        $0.text = ""
    }
    func loadProfileImage(url: String) {
        guard !url.isEmpty, let imageURL = URL(string: url) else {
            profileImage.backgroundColor = .red
            return
        }
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(
            with: imageURL,
            placeholder: nil,
            options: [
                .transition(.fade(1.0)),
                .forceTransition,
                .cacheOriginalImage,
                .scaleFactor(UIScreen.main.scale),
                
            ],
            completionHandler: nil
        )
        profileImage.alpha = 0.7
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
        
        profileImage.isUserInteractionEnabled = true
        editButton.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        profileImage.snp.makeConstraints {
            $0.edges.equalTo(containerView.layoutMarginsGuide)
        }
        
        informationContainer.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(profileImage.snp.height).multipliedBy(0.35)
        }
        
        nickname.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-180)
            $0.bottom.equalToSuperview().offset(-122)
        }
        
        developmentJobLabel.snp.makeConstraints {
            $0.top.equalTo(nickname.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(nickname)
            $0.bottom.equalToSuperview().offset(-50)
        }
        
        usedLanguageLabel.snp.makeConstraints {
            $0.top.equalTo(developmentJobLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(nickname)
        }
        
        
        editButton.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    @objc func didTapEditProfileButton(_ sender: UIButton) {
        delegate?.didTapEditProfileButton(in: self)
    }
    
}

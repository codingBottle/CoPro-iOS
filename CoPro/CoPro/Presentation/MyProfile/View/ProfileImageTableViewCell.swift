//
//  ProfileImageTableViewCell.swift
//  CoPro
//
//  Created by 박신영 on 1/12/24.
//

import UIKit
import SnapKit
import Then

class ProfileImageTableViewCell: UITableViewCell {
    
    let containerView = UIView()
    
    let editImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(systemName: "square.and.pencil.circle") {
            imageView.image = image
        }
        return imageView
    }()
    
    let profileImage = UIImageView(image : Image.coproLogo)
    let informationContainer = UIView()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let developmentJobLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let usedLanguageLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let buttonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hex: "#767680")
        return view
    }()
    let buttonImage = UIImageView(image:Image.edit_Profile)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        selectedBackgroundView = UIView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        addSubview(containerView)
        containerView.addSubview(profileImage)
        profileImage.addSubview(informationContainer)
        informationContainer.addSubviews(nameLabel, developmentJobLabel, usedLanguageLabel, buttonContainerView)
//        buttonContainerView.addSubview(buttonImage)
        buttonContainerView.addSubview(editImageView)
        
        
        containerView.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        
        containerView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
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
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(informationContainer.snp.width).multipliedBy(0.3)
        }
        
        developmentJobLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.width.equalTo(informationContainer.snp.width).multipliedBy(0.13)
        }
        
        usedLanguageLabel.snp.makeConstraints {
            $0.top.equalTo(developmentJobLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.width.equalTo(informationContainer.snp.width).multipliedBy(0.4)
        }
        
        buttonContainerView.do {
            $0.layer.cornerRadius = buttonContainerView.frame.size.width / 2
            $0.clipsToBounds = true
        }
        
        buttonContainerView.snp.makeConstraints {
            $0.width.equalTo(informationContainer.snp.width).multipliedBy(1.0/7)
            $0.height.equalTo(informationContainer.snp.height).multipliedBy(1.0 / 2.7)
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        editImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

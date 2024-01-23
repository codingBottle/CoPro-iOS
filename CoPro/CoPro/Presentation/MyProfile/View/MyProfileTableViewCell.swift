//
//  MyProfileTableViewCell.swift
//  CoPro
//
//  Created by 박신영 on 1/11/24.
//

import UIKit
import SnapKit
import Then

class MyProfileTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 17)
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let heartContainer: UIView = UIView()
        
    let heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(systemName: "heart.fill") {
            imageView.image = image
        }
        return imageView
    }()
    
    let heartCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 17)
        label.textColor = UIColor.init(hex: "#2577FE")
        return label
    }()
    
    let greaterthanContainer: UIView = UIView()
    
//    let greaterthanLabel: UILabel = {
//        let label = UILabel()
//        label.text = ">"
//        label.font = UIFont(name: "Pretendard-Regular", size: 17)
//        label.font = .systemFont(ofSize: 17, weight: .bold)
//        label.textColor = UIColor.init(hex: "#2577FE")
//        return label
//    }()
    let greaterthanImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(systemName: "greaterthan") {
            imageView.image = image
        }
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        selectedBackgroundView = UIView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyProfileTableViewCell {
    private func setLayout() {
        addSubviews(titleLabel, heartContainer, greaterthanContainer)
        heartContainer.addSubviews(heartImageView, heartCountLabel)
        greaterthanContainer.addSubviews(greaterthanImageView)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        heartContainer.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(54)
        }
        
        heartImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(20)
            $0.height.equalTo(17.5)
        }
        
        heartCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(heartImageView.snp.trailing).offset(6)
            $0.width.equalTo(28)
        }
        
        greaterthanContainer.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(54)
        }
        
        greaterthanImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(12)
            $0.height.equalTo(17)
        }
        
//        heartContainer.isHidden
//        greaterthanContainer.isHidden
        
    }
}

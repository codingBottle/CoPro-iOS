//
//  OppositeInfoCardView.swift
//  CoPro
//
//  Created by 박신영 on 2/26/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class OppositeInfoCardView: BaseView {
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
   
   let infoView = UIView()
   let infoStackView = UIStackView().then {
       $0.axis = .vertical
       $0.distribution = .fill
       $0.spacing = 8
       $0.alignment = .leading
   }
   let userNameLabel = UILabel().then {
       $0.textAlignment = .center
       $0.setPretendardFont(text: "", size: 18, weight: .medium, letterSpacing: 1.26)
       $0.textColor = UIColor.Black()
   }
   let userPartLabel = UILabel().then {
       $0.textAlignment = .center
       $0.setPretendardFont(text: "", size: 23, weight: .semibold, letterSpacing: 1.24)
       $0.textColor = UIColor.Black()
   }
   let userLangLabel = UILabel().then {
       $0.textAlignment = .center
       $0.setPretendardFont(text: "", size: 23, weight: .semibold, letterSpacing: 1.24)
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
           $0.height.equalTo(320)
        }
        infoView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cardImage.snp.bottom).offset(10)
           $0.bottom.equalToSuperview().inset(20)
            $0.width.equalToSuperview().inset(20)
        }
        infoStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
           $0.bottom.equalToSuperview()
        }
        
        infoIconStackView.snp.makeConstraints {
            $0.right.equalToSuperview()
           $0.bottom.equalToSuperview()
        }
        likeIcon.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        likeLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
        }
        
    }
}

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
   
   
   let informationContainer = UIStackView().then {
       $0.axis = .vertical
       $0.distribution = .fill
       $0.alignment = .fill
       $0.spacing = 8
   }

   func createLabel(text: String, size: CGFloat, weight: UIFont.Weight) -> UILabel {
       let strokeTextAttributes: [NSAttributedString.Key : Any] = [
           .strokeColor : UIColor.black,
           .foregroundColor : UIColor.white,
           .strokeWidth : -2.0,
       ]
       return UILabel().then {
           $0.setPretendardFont(text: text, size: size, weight: weight, letterSpacing: 1.23)
           $0.textColor = UIColor.White()
           $0.attributedText = NSAttributedString(string: text, attributes: strokeTextAttributes)
       }
   }

   lazy var nickname = createLabel(text: "테스트", size: 30, weight: .bold)
   lazy var developmentJobLabel = createLabel(text: "테스트", size: 24, weight: .medium)
   lazy var usedLanguageLabel = createLabel(text: "테스트", size: 24, weight: .medium)

//   let nickname = UILabel().then {
//      let strokeTextAttributes: [NSAttributedString.Key : Any] = [
//          .strokeColor : UIColor.black,
//          .foregroundColor : UIColor.white,
//          .strokeWidth : -2.0,
//      ]
//       $0.setPretendardFont(text: "테스트", size: 30, weight: .bold, letterSpacing: 1.23)
//       $0.textColor = UIColor.White()
//      $0.attributedText = NSAttributedString(string: "테스트", attributes: strokeTextAttributes)
//   }
//
//   let developmentJobLabel = UILabel().then {
//      let strokeTextAttributes: [NSAttributedString.Key : Any] = [
//          .strokeColor : UIColor.black,
//          .foregroundColor : UIColor.white,
//          .strokeWidth : -2.0,
//      ]
//       $0.setPretendardFont(text: "테스트", size: 13, weight: .medium, letterSpacing: 1.23)
//       $0.textColor = UIColor.White()
//      $0.attributedText = NSAttributedString(string: "테스트", attributes: strokeTextAttributes)
//   }
//
//   let usedLanguageLabel = UILabel().then {
//      let strokeTextAttributes: [NSAttributedString.Key : Any] = [
//          .strokeColor : UIColor.black,
//          .foregroundColor : UIColor.white,
//          .strokeWidth : -2.0,
//      ]
//       $0.setPretendardFont(text: "테스트", size: 13, weight: .medium, letterSpacing: 1.23)
//       $0.textColor = UIColor.White()
//      $0.attributedText = NSAttributedString(string: "테스트", attributes: strokeTextAttributes)
//   }

   
//   let buttonContainerView = UIView().then {
//      $0.layer.backgroundColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.2).cgColor
//      $0.clipsToBounds = true
//      $0.backgroundColor = .lightGray
//      $0.layer.cornerRadius = 25
//   }
   
   var editButton = UIButton().then {
      let symbolConfiguration = UIImage.SymbolConfiguration(scale: .large)
      let image = UIImage(systemName: "square.and.pencil", withConfiguration: symbolConfiguration)
      
      var buttonConfiguration = UIButton.Configuration.gray()
      buttonConfiguration.image = image
      buttonConfiguration.imagePadding = 10
      buttonConfiguration.background.backgroundColor = UIColor.white
      buttonConfiguration.cornerStyle = .capsule
      $0.configuration = buttonConfiguration
      $0.layer.borderColor = UIColor.P2().cgColor
      $0.layer.cornerRadius = 25
      $0.layer.borderWidth = 1
      $0.clipsToBounds = true
   }
   
   let imageUrl = UILabel().then{
      $0.text = ""
   }
   
   func loadProfileImage(url: String) {
      guard !url.isEmpty, let imageURL = URL(string: url) else {
         profileImage.backgroundColor = .red
         return
      }
      profileImage.kf.indicatorType = .none
      profileImage.kf.setImage(
         with: imageURL,
         placeholder: nil,
         options: [
//            .transition(.fade(1.0)),
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
      for i in [nickname, developmentJobLabel, usedLanguageLabel]{
          informationContainer.addArrangedSubview(i)
      }
      
      contentView.addSubview(containerView)
      containerView.addSubview(profileImage)
      profileImage.addSubviews(informationContainer, editButton)
      informationContainer.addSubviews(nickname, developmentJobLabel, usedLanguageLabel)
      
      profileImage.isUserInteractionEnabled = true
      editButton.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)
      
      containerView.snp.makeConstraints {
         $0.top.bottom.leading.trailing.equalToSuperview()
      }
      
      profileImage.snp.makeConstraints {
         $0.top.bottom.leading.trailing.equalToSuperview()
      }
      
      informationContainer.snp.makeConstraints {
              $0.leading.equalToSuperview().offset(16)
              $0.trailing.equalToSuperview().offset(-16)
              $0.bottom.equalToSuperview().offset(-10)
              $0.height.equalTo(UIScreen.main.bounds.height/2/2.5)
          }

      editButton.snp.makeConstraints {
              $0.width.equalTo(50)
              $0.height.equalTo(50)
              $0.bottom.equalToSuperview().offset(-10)
              $0.trailing.equalToSuperview().offset(-10)
          }
      
   }
   
   @objc func didTapEditProfileButton(_ sender: UIButton) {
      delegate?.didTapEditProfileButton(in: self)
   }
   
}

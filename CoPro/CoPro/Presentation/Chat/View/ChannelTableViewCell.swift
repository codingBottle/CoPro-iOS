//
//  ChannelTableViewCell.swift
//  CoPro
//
//  Created by 박신영 on 12/27/23.
//

import UIKit
import SnapKit
import Then

class ChannelTableViewCell: UITableViewCell {
    
    var channel: Channel? {
            didSet {
                guard let channel = channel else { return }
                chatRoomLabel.text = channel.name
                projectChip.isHidden = !channel.isProject
            }
        }
   var loadedImage: UIImage?
    var isProject = false
   
   var container = UIView()
//      .then({
//      $0.layer.borderWidth = 1
//      $0.layer.borderColor = UIColor.G2().cgColor
//   })
   
   var container2 = UIView()
//      .then({
//      $0.layer.borderWidth = 1
//      $0.layer.borderColor = UIColor.P2().cgColor
//   })
    
   var avatarImage = UIImageView().then {
      $0.clipsToBounds = true
   }
   
   let imageUrl = UILabel().then{
       $0.text = ""
   }
    
   lazy var chatRoomLabel = UILabel().then {
      $0.setPretendardFont(text: "test", size: 15, weight: .bold, letterSpacing: 1.22)
      $0.textAlignment = .center
   }
    
   var projectChipContainer = UIView().then {
      $0.backgroundColor = UIColor.G1()
      $0.layer.cornerRadius = 6
  }
   
   lazy var projectChip = UILabel().then {
      $0.setPretendardFont(text: "Project", size: 11, weight: .regular, letterSpacing: 1)
      $0.textColor = UIColor.Black()
      $0.textAlignment = .center
   }
    
    lazy var detailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
       
       contentView.addSubview(container)
       container.addSubviews(avatarImage, container2)
       container2.addSubviews(chatRoomLabel, detailButton)
//       projectChipContainer.addSubview(projectChip)
       avatarImage.isUserInteractionEnabled = true
       
       container.snp.makeConstraints {
          $0.top.leading.equalToSuperview().offset(16)
          $0.bottom.trailing.equalToSuperview().offset(-16)
       }
       
          avatarImage.snp.makeConstraints{
             $0.top.leading.bottom.equalToSuperview()
             $0.trailing.equalToSuperview().offset(-311)
          }
       
          container2.snp.makeConstraints {
             $0.leading.equalTo(avatarImage.snp.trailing).offset(12)
             $0.top.equalToSuperview().offset(2)
             $0.bottom.equalToSuperview().offset(-2)
             $0.trailing.equalToSuperview()
          }
       
      
           chatRoomLabel.snp.makeConstraints {
              $0.leading.equalToSuperview().offset(10)
              $0.width.lessThanOrEqualToSuperview().offset(-180)
              $0.centerY.equalToSuperview()
           }
        
//          projectChipContainer.snp.makeConstraints {
//             $0.leading.equalTo(chatRoomLabel.snp.trailing).offset(8)
//             $0.bottom.equalTo(chatRoomLabel)
//             $0.top.equalToSuperview().offset(5)
//             $0.trailing.equalToSuperview().offset(-185)
//          }
//         
//       projectChip.snp.makeConstraints {
//          $0.centerX.equalToSuperview()
//          $0.centerY.equalToSuperview()
//       }
        
        detailButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        detailButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-24)
        }
    }
   
   func loadChannelProfileImage(url: String) {
      guard !url.isEmpty, let imageURL = URL(string: url) else {
         print("채널 유저 프로필 이미지 불러오기 실패")
         avatarImage.backgroundColor = .red
         return
      }
      avatarImage.kf.setImage(
          with: imageURL,
          placeholder: nil,
          options: [
              .transition(.fade(1.0)),
              .forceTransition,
              .cacheOriginalImage,
              .scaleFactor(UIScreen.main.scale),
          ],
          completionHandler: { result in
              switch result {
              case .success(let value):
//                 print("Image: \(value.image). Got from: \(value.cacheType)")
                 self.loadedImage = value.image
//                 print("🔥\n",self.loadedImage ?? "")
              case .failure(let error):
                  print("Error: \(error)")
              }
          }
      )

   }
}


class PaddingLabel: UILabel {
    var topInset: CGFloat = 5.0
    var bottomInset: CGFloat = 5.0
    var leftInset: CGFloat = 10.0
    var rightInset: CGFloat = 10.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}

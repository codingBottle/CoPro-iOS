//
//  CustomMessageContentCell.swift
//  CoPro
//
//  Created by 박신영 on 12/27/23.
//

import UIKit
import MessageKit

class CustomMessageContentCell: MessageContentCell {
    
    var customAvatarView: UIView = {
        let view = UIView()
        // Configure your avatar view here
        // Add styling or avatar image/icon
        return view
    }()
    
    var customMessageContainerView: UIView = {
        let view = UIView()
        // Configure your message container view here
        // Add styling, background color, etc.
        return view
    }()
   
   override init(frame: CGRect) {
       super.init(frame: frame)
       
       addSubview(customAvatarView)
       addSubview(customMessageContainerView)

       customAvatarView.snp.makeConstraints {
           $0.leading.equalToSuperview()
           $0.width.equalTo(40)  // Set your desired width
           $0.height.equalTo(customAvatarView.snp.width)
           $0.top.equalToSuperview()
       }

       customMessageContainerView.snp.makeConstraints {
           $0.leading.equalTo(customAvatarView.snp.trailing).offset(8) // Add spacing between avatar and message
           $0.trailing.equalToSuperview()
           $0.top.bottom.equalToSuperview()
           // Add other constraints to properly layout the messageContainerView
       }
   }

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        addSubview(customAvatarView)
//        addSubview(customMessageContainerView)
//        // Add constraints to position and layout your custom views
//        // Use constraints or frames to position avatarView and messageContainerView
//        
//        // Example constraints (modify as per your layout requirements)
//        customAvatarView.translatesAutoresizingMaskIntoConstraints = false
//        customMessageContainerView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            customAvatarView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            customAvatarView.widthAnchor.constraint(equalToConstant: 40), // Set your desired width
//            customAvatarView.heightAnchor.constraint(equalTo: customAvatarView.widthAnchor),
//            customAvatarView.topAnchor.constraint(equalTo: topAnchor),
//            
//            customMessageContainerView.leadingAnchor.constraint(equalTo: customAvatarView.trailingAnchor, constant: 8), // Add spacing between avatar and message
//            customMessageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            customMessageContainerView.topAnchor.constraint(equalTo: topAnchor),
//            customMessageContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)
//            // Add other constraints to properly layout the messageContainerView
//        ])
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

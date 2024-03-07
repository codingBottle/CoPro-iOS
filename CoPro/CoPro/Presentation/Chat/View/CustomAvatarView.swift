//
//  CustomAvatarView.swift
//  ChatTest
//
//  Created by 박신영 on 12/17/23.
//

import UIKit
import MessageKit

class CustomAvatarView: AvatarView {
   
   override func layoutSubviews() {
      super.layoutSubviews()
      
      // 원하는 위치와 크기로 설정
      let desiredFrame = CGRect(x: 20, y: 20, width: 40, height: 40)
      self.frame = desiredFrame
      self.clipsToBounds = true
   }
}

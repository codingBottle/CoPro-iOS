//
//  OppositeInfoCardViewController.swift
//  CoPro
//
//  Created by 박신영 on 2/26/24.
//

import UIKit
import Then
import SnapKit
import KeychainSwift

class OppositeInfoCardViewController: BaseViewController {
   let cardView = OppositeInfoCardView()
   var isLike: Bool!
   var likeCount: Int?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = UIColor.White()
      
      
   }
   
   
   override func setUI() {
      if let sheetPresentationController = sheetPresentationController {
         sheetPresentationController.preferredCornerRadius = 15
         sheetPresentationController.prefersGrabberVisible = true
         sheetPresentationController.detents = [.custom {context in
                     return UIScreen.main.bounds.height*0.6}]
      
      }
      view.addSubview(cardView)
   }
   
   override func setLayout() {
      
      cardView.snp.remakeConstraints {
         $0.centerX.equalToSuperview()
         $0.top.equalToSuperview().offset(30)
         $0.left.right.equalToSuperview().inset(10)
         $0.bottom.equalToSuperview().inset(40)
      }
      
     
   }
   
   func oppositeInfoCardViewConfigure(with imageUrl: String, nickname: String, occupation: String, language: String, likeCount: Int, isLike: Bool) {
      cardView.loadImage(url: imageUrl)
      cardView.userNameLabel.text = nickname
      cardView.userPartLabel.text = occupation
      cardView.userLangLabel.text = language
      cardView.likeLabel.text = String(likeCount)
      self.likeCount = likeCount
      self.isLike = isLike
      if isLike == true {
         self.cardView.likeIcon.tintColor = UIColor.P2()// 아이콘 색상을 파란색으로 변경
         self.cardView.likeLabel.textColor = UIColor.P2()
      }else{
         self.cardView.likeIcon.tintColor = UIColor.G1()// 아이콘 색상을 파란색으로 변경
         self.cardView.likeLabel.textColor = UIColor.White()
      }
   }
}

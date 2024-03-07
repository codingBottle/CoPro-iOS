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
   var likeMemberId: Int?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = UIColor.clear
//      modalPresentationStyle = .flipHorizontal
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeIconTapped))
      cardView.likeIcon.addGestureRecognizer(tapGesture)
   }
   
   
   override func setUI() {
      if let sheetPresentationController = sheetPresentationController {
         sheetPresentationController.preferredCornerRadius = 15
         sheetPresentationController.prefersGrabberVisible = false
         sheetPresentationController.detents = [.custom {context in
            return UIScreen.main.bounds.height*0.8}]
      
      }
      view.addSubview(cardView)
   }
   
   override func setLayout() {
      
      cardView.snp.remakeConstraints {
         $0.centerX.equalToSuperview()
         $0.top.equalToSuperview().offset(30)
         $0.left.right.equalToSuperview().inset(10)
         $0.bottom.equalToSuperview().inset(UIScreen.main.bounds.height*0.8 * 0.3)
      }
      
     
   }
   
   func oppositeInfoCardViewConfigure(with imageUrl: String, nickname: String, occupation: String, language: String, likeCount: Int, isLike: Bool, memberID: Int) {
      cardView.loadImage(url: imageUrl)
      cardView.userNameLabel.text = nickname
      cardView.userPartLabel.text = occupation
      cardView.userLangLabel.text = language
      cardView.likeLabel.text = String(likeCount)
      self.likeCount = likeCount
      self.likeMemberId = memberID
      self.isLike = isLike
      if isLike == true {
         self.cardView.likeIcon.tintColor = UIColor.P2()// 아이콘 색상을 파란색으로 변경
         self.cardView.likeLabel.textColor = UIColor.P2()
      }else{
         self.cardView.likeIcon.tintColor = UIColor.G1()// 아이콘 색상을 파란색으로 변경
         self.cardView.likeLabel.textColor = UIColor.White()
      }
   }
   
   @objc func likeIconTapped() {
      if isLike == true{
         CardAPI.shared.cancelLike(MemberId:likeMemberId!) { success in
            if success {
               // API 호출이 성공하면 UI 업데이트
               DispatchQueue.main.async {
                  guard let currentCount = Int(self.cardView.likeLabel.text ?? "0") else { return }
                  let newCount = currentCount - 1
                  self.cardView.likeLabel.text = "\(newCount)"
                  self.cardView.likeIcon.tintColor = UIColor.G1()
                  self.cardView.likeLabel.textColor = UIColor.White()
                  print("좋아요 취소 후 좋아요 수 \(String(describing: self.likeCount))")
                  self.isLike = false
                  print("좋아요 여부 \(String(describing: self.isLike))")
               }
            }
         }
         
      }else{
         CardAPI.shared.addLike(MemberId:likeMemberId!) { success in
            if success {
               // API 호출이 성공하면 UI 업데이트
               DispatchQueue.main.async {
                  guard let currentCount = Int(self.cardView.likeLabel.text ?? "0") else { return }
                  let newCount = currentCount + 1
                  self.cardView.likeLabel.text = "\(newCount)"
                  self.cardView.likeIcon.tintColor = UIColor.P2() // 아이콘 색상을 파란색으로 변경
                  self.cardView.likeLabel.textColor = UIColor.P2() // 라벨 색상을 파란색으로 변경
                  
                  
                  print("좋아요 후 좋아요 수 \(String(describing: self.likeCount))")
                  
                  self.isLike = true
                  print("좋아요 여부 \(String(describing: self.isLike))")
               }
            }
         }
      }
      
   }
}

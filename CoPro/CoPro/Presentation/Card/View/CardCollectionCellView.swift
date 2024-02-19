//
//  CardCollectionCellView.swift
//  CoPro
//
//  Created by 박현렬 on 1/22/24.
//

import UIKit
import SnapKit
import Then
import KeychainSwift

protocol CardCollectionCellViewDelegate: AnyObject {
    func didTapChatButtonOnCardCollectionCellView(in cell: CardCollectionCellView, success: Bool)
}

class CardCollectionCellView: UICollectionViewCell {
   private let channelStream = ChannelFirestoreStream()
   let slideCardView = SlideCardView()
   var gitButtonURL: String?
   var likeMemberId: Int?
   var likeCount: Int?
   var isLike: Bool!
   var imageURL: String?
   weak var CardCollectionCellViewdelegate: CardCollectionCellViewDelegate?
   override init(frame: CGRect) {
      super.init(frame: frame)
      setupUI()
      setupAddTarget()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   private func setupUI() {
      contentView.addSubview(slideCardView)
      slideCardView.snp.makeConstraints {
         $0.centerX.equalToSuperview()
         $0.top.equalToSuperview()
         $0.left.right.equalToSuperview().inset(10)
         $0.bottom.equalToSuperview().inset(40)
      }
   }
   override func prepareForReuse() {
      super.prepareForReuse()
      self.isLike = nil
   }
   private func setupAddTarget() {
      slideCardView.gitButton.addTarget(self, action: #selector(gitButtonTapped), for: .touchUpInside)
      slideCardView.chatButton.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
      // 아이콘을 터치했을 때의 제스처 추가
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeIconTapped))
      slideCardView.likeIcon.addGestureRecognizer(tapGesture)
   }
   
   //Github버튼 동작 메소드
   @objc func gitButtonTapped() {
      if let gitURL = gitButtonURL {
         print("Git 버튼이 눌렸습니다. URL: \(gitURL)")
         // Open the URL in Safari
         if gitButtonURL == " "{
            print("URL미등록")
         }else{
            UIApplication.shared.open(URL(string: gitButtonURL!)!, options: [:], completionHandler: nil)
         }
      } else {
         print("Git 버튼이 눌렸지만 URL이 없습니다.")
      }
   }
   
   //MARK: - Chat버튼 동작 메소드
   
   @objc func chatButtonTapped(_ sender: UIButton) {
      print("Chat 버튼이 눌렸습니다.")
      let keychain = KeychainSwift()
      guard let receiverurl = imageURL else { return print("chatButtonTapped의 imageURL 에러") }
      guard let currentUserNickName = keychain.get("currentUserNickName") else {return print("컬렉션뷰에서 채팅방 생성할 때에 currentUserNickName 값 에러")}
      guard let currentUserProfileImage = keychain.get("currentUserProfileImage") else {return print("컬렉션뷰에서 채팅방 생성할 때에 currentUserNickName 값 에러")}
      channelStream.createChannel(sender: currentUserNickName, receiver: slideCardView.userNameLabel.text ?? "", senderProfileImage: currentUserProfileImage, receiverProfileImage: receiverurl, occupation: slideCardView.userPartLabel.text ?? "", unreadCount: 0) {error in
         if let error = error {
            // 실패: 오류 메시지를 출력하거나 사용자에게 오류 상황을 알립니다.
            print("Failed to create channel: \(error.localizedDescription)")
            self.CardCollectionCellViewdelegate?.didTapChatButtonOnCardCollectionCellView(in: self, success: false)
         } else {
            // 성공: 채팅 버튼을 탭하거나 필요한 다른 동작을 수행합니다.
            self.CardCollectionCellViewdelegate?.didTapChatButtonOnCardCollectionCellView(in: self, success: true)
         }
      }
   }
   
   //좋아요 아이콘을 터치했을 때 실행되는 메서드
   @objc func likeIconTapped() {
      if isLike == true{
         CardAPI.shared.cancelLike(MemberId:likeMemberId!) { success in
            if success {
               // API 호출이 성공하면 UI 업데이트
               DispatchQueue.main.async {
                  guard let currentCount = Int(self.slideCardView.likeLabel.text ?? "0") else { return }
                  let newCount = currentCount - 1
                  self.slideCardView.likeLabel.text = "\(newCount)"
                  self.slideCardView.likeIcon.tintColor = UIColor.G1()
                  self.slideCardView.likeLabel.textColor = UIColor.White()
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
                  guard let currentCount = Int(self.slideCardView.likeLabel.text ?? "0") else { return }
                  let newCount = currentCount + 1
                  self.slideCardView.likeLabel.text = "\(newCount)"
                  self.slideCardView.likeIcon.tintColor = UIColor.P2() // 아이콘 색상을 파란색으로 변경
                  self.slideCardView.likeLabel.textColor = UIColor.P2() // 라벨 색상을 파란색으로 변경
                  
                  
                  print("좋아요 후 좋아요 수 \(String(describing: self.likeCount))")
                  
                  self.isLike = true
                  print("좋아요 여부 \(String(describing: self.isLike))")
               }
            }
         }
      }
      
   }
   
   func configure(with imageUrl: String,name: String, occupation: String, language: String,gitButtonURL: String,likeCount: Int,memberId: Int,isLike: Bool) {
      self.gitButtonURL = gitButtonURL
      self.imageURL = imageUrl
      slideCardView.loadImage(url: imageUrl)
      slideCardView.userNameLabel.text = name
      slideCardView.userPartLabel.text = occupation
      slideCardView.userLangLabel.text = language
      slideCardView.likeLabel.text = String(likeCount)
      self.likeCount = likeCount
      self.likeMemberId = memberId
      self.isLike = isLike
      print("configure IsLike\(isLike)")
      if isLike == true {
         self.slideCardView.likeIcon.tintColor = UIColor.P2()// 아이콘 색상을 파란색으로 변경
         self.slideCardView.likeLabel.textColor = UIColor.P2()
      }else{
         self.slideCardView.likeIcon.tintColor = UIColor.G1()// 아이콘 색상을 파란색으로 변경
         self.slideCardView.likeLabel.textColor = UIColor.White()
      }
   }
}
